class CreateOrderCustomers < ActiveRecord::Migration
  def change
    create_table :order_customers do |t|
      t.integer :order_id
      t.string  :order_type
      t.integer :customer_id
      t.timestamps
    end
  end
end
