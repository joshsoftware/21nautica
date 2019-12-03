class Truck < ActiveRecord::Base
  STATUS = ['free', 'alloted', 'grounded']
  TYPE = ['Truck', 'Trailer']

  FREE = 'free'.freeze
  ALLOTED = 'alloted'.freeze

  TRUCK = 'Truck'

  has_many :job_cards
  has_many :import_items
  has_many :location_dates
  has_many :req_sheets
  has_many :breakdown_managements
  belongs_to :current_import_item, class_name: "ImportItem"
  has_many :petty_cashes
  has_many :fuel_entries
  validates :type_of, inclusion: { in: TYPE }
  validates_presence_of :reg_number

  scope :free, -> { where(status: FREE) }
  scope :alloted, -> { where(status: ALLOTED) }
  scope :active, -> { where(is_active: true) }
  before_validation :set_status_and_type, on: :create
  after_save :reset_third_party_truck_status


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

  def reset_third_party_truck_status
    #0 is id of third party truck and should always be free
    if self.id == 0
      self.update_column(:status, FREE)
    end
  end
end

