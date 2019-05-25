class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.string :number
      t.date :date
      t.float :total_cost
      t.references :vendor, index: true

      t.timestamps
    end
  end
end
