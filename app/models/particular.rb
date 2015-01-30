class Particular < ActiveRecord::Base
  belongs_to :invoice
  validates :rate, numericality: { only_integer: true , greater_than: 0}
  validates_presence_of :name
end
