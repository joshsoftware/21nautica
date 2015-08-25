class CreateBillItems < ActiveRecord::Migration
  def change
    create_table :bill_items do |t|
      t.integer :serial_number
      t.string :item_type
      t.belongs_to :bill
      t.datetime :bill_date
      t.belongs_to :vendor
      t.string :item_for, default: 'bl'
      t.text :item_number
      t.text :charge_for
      t.integer :quantity
      t.float :rate
      t.float :line_amount
      t.belongs_to :activity, polymorphic: true, index: true
      t.timestamps
    end
  end
end
