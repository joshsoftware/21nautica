class SparePart < ActiveRecord::Base
  belongs_to :spare_part_category
  belongs_to :spare_part_sub_category, class_name: 'SparePartCategory'

  validates_presence_of :product_name, :spare_part_category_id
end
