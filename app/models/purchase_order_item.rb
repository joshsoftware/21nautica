class PurchaseOrderItem < ActiveRecord::Base
  belongs_to :truck
  belongs_to :spare_part
  belongs_to :purchase_order
end
