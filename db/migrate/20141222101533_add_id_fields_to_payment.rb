class AddIdFieldsToPayment < ActiveRecord::Migration
  def change
  	add_column :payments, :customer_id, :integer
    add_column :payments, :vendor_id, :integer
  end
end
