class CreateBillOfLadings < ActiveRecord::Migration
  def change
    create_table :bill_of_ladings do |t|
      t.string :bl_number
      t.string :payment_ocean
      t.string :cheque_ocean
      t.string :shipping_line
      t.string :clearing_agent
      t.string :payment_clearing
      t.string :cheque_clearing
      t.string :remarks

      t.timestamps
    end
  end
end
