class ReqPart < ActiveRecord::Base
  belongs_to :spare_part
  belongs_to :mechanic
  belongs_to :req_sheet

  validates_presence_of :mechanic_id, :spare_part_id, :price, :quantity
  validates :price, :quantity, numericality: { greater_than: 0 }
end
