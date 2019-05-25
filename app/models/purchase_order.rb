class PurchaseOrder < ActiveRecord::Base
  belongs_to :vendor
  has_many :purchase_order_items

  accepts_nested_attributes_for :purchase_order_items, allow_destroy: true
end
