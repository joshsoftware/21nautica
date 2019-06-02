class AddOfTypeIntoPurchaseOrderItem < ActiveRecord::Migration
  def change
    add_column :purchase_order_items, :of_type, :string
  end
end
