class Truck < ActiveRecord::Base
  TYPE = ['Truck', 'Trailer']

  validates :type_of, inclusion: { in: TYPE }
  validates_presence_of :reg_number

  def is_truck?
    type_of == 'Truck'
  end
end
