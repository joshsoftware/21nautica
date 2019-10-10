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
  include Remarkable

  has_many :import_items, :dependent => :destroy
  has_many :bill_items, as: :activity
  belongs_to :customer
  belongs_to :bill_of_lading
  belongs_to :c_agent, class_name: "Vendor", foreign_key: "clearing_agent_id"
  belongs_to :shipping_line, class_name: "Vendor"
  before_save :strip_container_number_bl_number, :save_entry_type, :shipping_date_chronology, :change_status
  after_save :late_document_mail, :rotation_number_mail
  after_create :set_bl_received, :generate_invoice

  validates_presence_of :rate_agreed, :to, :from, :weight, :bl_number, :bl_received_type
  validates_presence_of :work_order_number, on: :create
  validates_uniqueness_of :bl_number
  validates_format_of :bl_received_at, :with => /\d{4}\-\d{2}\-\d{2}/, :message => "^Date must be in the following format: yyyy/mm/dd", :allow_blank => true
  validate :shouldnt_be_future_date

  accepts_nested_attributes_for :import_items

  enum entry_type: ["wt8", "im4"]
  enum bl_received_type: ["copy", "original_telex"]

  # scope :ready_to_load, -> {where(status: 'ready_to_load')}
  # scope :not_ready_to_load, -> {where.not(status: 'ready_to_load')}

  scope :ready_to_load,  -> {where("CASE WHEN new_import = TRUE THEN (bl_received_at IS NOT NULL AND entry_number IS NOT NULL AND entry_type IS NOT NULL ) ELSE status = 'ready_to_load' END")}
  scope :not_ready_to_load,  -> {where("CASE WHEN new_import = TRUE THEN (bl_received_at IS NULL OR entry_number IS NULL OR entry_type IS NULL ) ELSE status != 'ready_to_load' END")}

  # scope :shipping_dates_not_present, -> {where("bl_received_at IS NULL OR charges_received_at IS NULL OR charges_paid_at IS NULL OR do_received_at IS NULL OR gf_return_date IS NULL")}
  # scope :custom_entry_not_generated, -> {where("entry_number IS NULL OR entry_type IS NULL")}
  # scope :custom_shipping_dates_not_present, -> {where("entry_number IS NULL OR entry_type IS NULL OR bl_received_at IS NULL OR charges_received_at IS NULL OR charges_paid_at IS NULL OR do_received_at IS NULL OR gf_return_date IS NULL")}

  #following code will be needed when we add new_import_flag to import table
  scope :shipping_dates_not_present, -> {where("CASE WHEN new_import = TRUE THEN (bl_received_at IS NULL OR charges_received_at IS NULL OR charges_paid_at IS NULL OR do_received_at IS NULL OR pl_received_at IS NULL OR gf_return_date IS NULL) ELSE status != 'ready_to_load' END")}
  # scope :shipping_dates_present, -> {where.not("CASE WHEN new_import = TRUE THEN (bl_received_at IS NULL OR charges_received_at IS NULL OR charges_paid_at IS NULL OR do_received_at IS NULL OR pl_received_at IS NULL OR gf_return_date IS NULL) ELSE TRUE END")}
  scope :custom_entry_not_generated, -> {where("CASE WHEN new_import = TRUE THEN (entry_number IS NULL OR entry_type IS NULL) ELSE status != 'ready_to_load' END")}
  # scope :custom_entry_generated, -> {where("CASE WHEN new_import = TRUE THEN (entry_number IS NOT NULL AND entry_type IS NOT NULL) ELSE TRUE END")}

  # Hack: I have intentionally not used delegate here, because,
  # in case of duplicate, the bl_number will be delegated to a non-existent BillOfLading in
  # the `render :new` call. :allow_nil would not work, as we actually lose the bl_number then!

  def set_new_import_flag
    #This flag is used after splitting the port operation table into custom and shipping line. Few fields and 
    # conditions were added so we need to differentiate the new and old imports.
    self.new_import = true
  end

  def presence_of_date#going to use for date chronology
    ["bl_received_at", "charges_received_at", "charges_paid_at", "do_received_at"].each do |date|
      if self.send("#{date}_changed?".to_sym) && !self.send(date.to_sym).present?
        date_msg = date.split("_")
        date_msg[2] = "date"
        self.errors.add(:base, "#{date_msg.join(" ")} can not be set as empty once filled")
      end
    end
    !self.errors.present?
  end

  def bl_number
    self.bill_of_lading.try(:bl_number) ? self.bill_of_lading.bl_number : self.attributes["bl_number"]
  end

  def cargo_receipt
    return self.attributes['bl_number'] if self.attributes['bl_number']
    bl_number
  end

  def strip_container_number_bl_number
    self.bl_number = self.bl_number.strip
    self.import_items.each do |import_item|
      import_item.container_number = import_item.container_number.strip
      import_item.last_loading_date = estimate_arrival + 8.days if estimate_arrival.present?
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

  def is_wecline_shipping?
    return false unless shipping_line
    shipping_line.name == 'WECLINES'
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
  
  def late_document_mail
    if estimate_arrival_changed? && estimate_arrival < DateTime.now
      UserMailer.late_document_mail(self).deliver()
    end
  end

  def custom_entry_generated?
    entry_number.present? && entry_type.present?
  end

  def set_bl_received
    if bl_received_type == "original_telex"
      self.update_column(:bl_received_at, Date.today)
    end
  end

  def rotation_number_mail
    if rotation_number_changed? && rotation_number.present?
      # UserMailer.rotation_number_mail(self).deliver()
    end
  end

  def shipping_checked?
    bl_received_at.present? && charges_received_at.present? && charges_paid_at.present? && do_received_at.present?
  end

  def save_entry_type
    if entry_number && entry_number.downcase.start_with?("c")
      self.entry_type = 1
    elsif entry_number
      self.entry_type = 0
    end
  end

  def shipping_date_chronology
    if bl_received_at_changed? || charges_received_at_changed? || charges_paid_at_changed? || do_received_at_changed?
      if !bl_received_at.present?
        self.charges_received_at, self.charges_paid_at, self.do_received_at = nil
      elsif !charges_received_at.present?
        self.charges_paid_at, self.do_received_at = nil
      elsif !charges_paid_at.present?
        self.do_received_at = nil
      end
    end
  end

  def change_status
    if bl_received_at_changed? && bl_received_at.present? && custom_entry_generated?
      self.status = "ready_to_load"
    end
  end

  def shouldnt_be_future_date
    if bl_received_at && bl_received_at > Date.today
      self.errors.add(:base, "BL received date can not be set as future date")
    end
    if charges_received_at && charges_received_at > Date.today
      self.errors.add(:base, "Charges received date can not be set as future date")
    end
    if charges_paid_at && charges_paid_at > Date.today
      self.errors.add(:base, "Charges paid date can not be set as future date")
    end
    if do_received_at && do_received_at > Date.today
      self.errors.add(:base, "Delivery order received date can not be set as future date")
    end
    if gf_return_date && gf_return_date > Date.today
      self.errors.add(:base, "Guarantee form return date can not be set as future date")
    end
  end

  auditable only: [:status, :updated_at, :remark]

  def generate_invoice
    invoice = bill_of_lading.invoices.build(date: Date.today, customer_id: customer_id)
    invoice.save
    invoice.invoice_ready!
  end

end
