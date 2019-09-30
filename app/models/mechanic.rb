class Mechanic < ActiveRecord::Base

  validates :name, presence: true
end
