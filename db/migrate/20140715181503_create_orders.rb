class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :equipment
      t.integer :quantity
      t.string :type
      t.timestamps
    end
  end
end
