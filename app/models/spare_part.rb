class SparePart < ActiveRecord::Base
  belongs_to :spare_part_category
  belongs_to :spare_part_sub_category, class_name: 'SparePartCategory'
  has_many :purchase_order_items
  has_many :req_parts
  has_many :spare_part_ledgers
  validates_presence_of :product_name, :spare_part_category_id
end
