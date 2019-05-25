class CreatePurchaseOrderItems < ActiveRecord::Migration
  def change
    create_table :purchase_order_items do |t|
      t.references :truck, index: true
      t.references :spare_part, index: true
      t.references :purchase_order, index: true
      t.string :part_make
      t.integer :quantity
      t.float :price
      t.float :total_price

      t.timestamps
    end
  end
end
