class SetToDefaultValueInVendorLedger < ActiveRecord::Migration
  def change
    change_column :vendor_ledgers, :paid, :float, default: 0
  end
end
