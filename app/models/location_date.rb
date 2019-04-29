class LocationDate < ActiveRecord::Base
  belongs_to :truck
  validates_presence_of :date, :location, :truck_id
end
