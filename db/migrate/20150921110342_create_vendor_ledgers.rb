class CreateVendorLedgers < ActiveRecord::Migration
  def change
    create_table :vendor_ledgers do |t|
      t.references :vendor, index: true
      t.integer :voucher_id
      t.string :voucher_type
      t.float :amount
      t.string :paid
      t.date :bill_date

      t.timestamps
    end
  end
end
