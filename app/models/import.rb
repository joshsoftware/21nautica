# == Schema Information
#
# Table name: imports
#
#  id               :integer          not null, primary key
#  equipment        :string(255)
#  quantity         :integer
#  from             :string(255)
#  to               :string(255)
#  bl_number        :string(255)
#  estimate_arrival :date
#  description      :string(255)
#  rate             :string(255)
#  status           :string(255)
#  out_of_port_date :date
#  customer_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'patch'

class Import < ActiveRecord::Base
  include AASM
  include EspinitaPatch

  has_many :import_items, :dependent => :destroy
  has_many :bill_items, as: :activity
  belongs_to :customer
  belongs_to :bill_of_lading
  belongs_to :c_agent, class_name: "Vendor", foreign_key: "clearing_agent_id"
  belongs_to :shipping_line, class_name: "Vendor"
  before_save :strip_container_number_bl_number

  validates_presence_of :rate_agreed, :to, :from, :weight, :bl_number
  validates_uniqueness_of :bl_number

  accepts_nested_attributes_for :import_items

  # Hack: I have intentionally not used delegate here, because,
  # in case of duplicate, the bl_number will be delegated to a non-existent BillOfLading in
  # the `render :new` call. :allow_nil would not work, as we actually lose the bl_number then!
  def bl_number
    self.bill_of_lading.try(:bl_number) ? self.bill_of_lading.bl_number : self.attributes["bl_number"]
  end

  def strip_container_number_bl_number
    self.bl_number = self.bl_number.strip
    self.import_items.each do |import_item|
      import_item.container_number = import_item.container_number.strip
    end
  end

  before_create do |record|
    # create the bill_of_lading
    # Hack: Since we are creating a parent before the child is saved,
    # we need to manipulate the system a little bit
    bl = BillOfLading.new(bl_number: record["bl_number"])
    if bl.save
      record.bill_of_lading = bl
    else
      record.errors.messages.merge!(bl.errors.messages)
      false
    end
  end

  aasm column: 'status' do
    state :copy_documents_received, initial: true
    state :original_documents_received
    state :container_discharged
    state :ready_to_load

    event :original_documents_received do
      transitions from: :copy_documents_received, to: :original_documents_received
    end

    event :container_discharged do
      transitions from: :original_documents_received, to: :container_discharged
    end

    event :ready_to_load do
      transitions from: :container_discharged, to: :ready_to_load, guard: :is_work_order_and_entry_number_assigned
    end

  end

  def is_work_order_and_entry_number_assigned
    !work_order_number.blank? && !entry_number.blank?
  end

  def clearing_agent
    self.c_agent.try(:name)
  end

  def clearing_agent=(clearing_agent)
    self.c_agent = Vendor.where(name: clearing_agent).first
  end

  auditable only: [:status, :updated_at, :remarks]

end
