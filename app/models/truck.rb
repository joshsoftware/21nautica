class Truck < ActiveRecord::Base
  STATUS = ['free', 'alloted', 'grounded']
  TYPE = ['Truck', 'Trailer']

  FREE = 'free'.freeze
  ALLOTED = 'alloted'.freeze

  TRUCK = 'Truck'

  has_many :import_items
  belongs_to :current_import_item, class_name: "ImportItem"

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
end
