class SparePartCategory < ActiveRecord::Base

  has_many :spare_part_categories, dependent: :destroy, foreign_key: 'sub_category_id'
  belongs_to :sub_category, class_name: 'SparePartCategory'

  scope :main, -> { where(sub_category_id: nil) }
  validates_uniqueness_of :name
end
