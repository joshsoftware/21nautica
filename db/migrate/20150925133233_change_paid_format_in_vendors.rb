class ChangePaidFormatInVendors < ActiveRecord::Migration
  def change
    remove_column :vendor_ledgers, :paid
    add_column :vendor_ledgers, :paid, :float
  end
end
