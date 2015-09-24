class RenameColumnBillDateToDate < ActiveRecord::Migration
  def change
    rename_column :vendor_ledgers, :bill_date, :date
  end
end
