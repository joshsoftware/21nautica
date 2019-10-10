class Truck < ActiveRecord::Base
  STATUS = ['free', 'alloted', 'grounded']
  TYPE = ['Truck', 'Trailer']

  FREE = 'free'.freeze
  ALLOTED = 'alloted'.freeze

  TRUCK = 'Truck'

  has_many :job_cards
  has_many :transport_manager_cashes
  has_many :import_items
  has_many :location_dates
  belongs_to :current_import_item, class_name: "ImportItem"
  has_many :petty_cashes
  validates :type_of, inclusion: { in: TYPE }
  validates_presence_of :reg_number

  scope :free, -> { where(status: FREE) }

  before_validation :set_status_and_type, on: :create

  def is_truck?
    type_of == TRUCK 
  end

  def set_status_and_type
    self.status = FREE if status.nil?
    self.type_of = TRUCK 
  end

  def self.update_location(truck_number, truck_location)
    return unless truck_number.present? && truck_location.present?
    truck = Truck.where('lower(reg_number) = lower(?)', truck_number.strip).last
    return if truck.nil?
    location = LocationDate.find_or_initialize_by(date: Date.today, truck_id: truck.id)
    location.update_attributes(location: truck_location)
    truck.update_attributes(location: truck_location)
  end
end
