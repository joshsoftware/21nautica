class LocalImport < ActiveRecord::Base
  belongs_to :customer
  belongs_to :bill_of_lading
  belongs_to :shipping_line, class_name: "Vendor"
  validates_uniqueness_of :bl_number, allow_blank: true
  validates_presence_of :reference_number, :customer
  has_many :remarks, as: :remarkable
  has_many :local_import_items, dependent: :destroy
  accepts_nested_attributes_for :local_import_items, allow_destroy: true
end
