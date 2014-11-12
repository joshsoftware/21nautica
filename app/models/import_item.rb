# == Schema Information
#
# Table name: import_items
#
#  id               :integer          not null, primary key
#  container_number :string(255)
#  trailer_number   :string(255)
#  tr_code          :string(255)
#  truck_number     :string(255)
#  current_location :string(255)
#  bond_direction   :string(255)
#  bond_number      :string(255)
#  status           :string(255)
#  import_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ImportItem < ActiveRecord::Base
  include AASM
  include EspinitaPatch

  belongs_to :import
  has_many :import_expenses, dependent: :destroy

  validate :assignment_of_truck_number, if: "truck_number.present? && truck_number_changed?"

  delegate :bl_number, to: :import

  accepts_nested_attributes_for :import_expenses

  after_create do |record|
    CATEGORIES.each do |category|
      record.import_expenses.create(category: category)
    end
  end

  def assignment_of_truck_number
    count = ImportItem.where(truck_number: truck_number).where.not(status: 'delivered').count
    if count > 0 && truck_number != nil
      errors.add(:truck_number," #{truck_number} is not free !")
    end
  end

  aasm column: 'status' do
    state :under_loading_process, initial: true
    state :truck_allocated
    state :loaded_out_of_port
    state :arrived_at_malaba
    state :departed_from_malaba
    state :arrived_at_kampala
    state :delivered

    event :allocate_truck do
      transitions from: :under_loading_process, to: :truck_allocated
    end

    event :loaded_out_of_port do
      transitions from: :truck_allocated, to: :loaded_out_of_port
    end

    event :arrived_at_malaba do
      transitions from: :loaded_out_of_port, to: :arrived_at_malaba
    end

    event :departed_from_malaba do
      transitions from: :arrived_at_malaba, to: :departed_from_malaba
    end

    event :arrived_at_kampala do
      transitions from: :departed_from_malaba, to: :arrived_at_kampala
    end

    event :truck_released do
      transitions from: :arrived_at_kampala, to: :delivered
    end

  end

  auditable only: [:status, :updated_at, :current_location, :remarks]

end
