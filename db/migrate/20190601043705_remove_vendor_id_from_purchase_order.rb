class RemoveVendorIdFromPurchaseOrder < ActiveRecord::Migration
  def change
    remove_column :purchase_orders, :vendor_id
    add_reference :purchase_orders, :supplier, index: true
  end
end
