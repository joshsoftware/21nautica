class AddCurrencyToVendorLedger < ActiveRecord::Migration
  def change
    add_column :vendor_ledgers, :currency, :string
  end
end
