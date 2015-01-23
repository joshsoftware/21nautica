class RenameInvoicePerticular < ActiveRecord::Migration
  def change
  	rename_table :invoice_perticulars, :particulars
  end
end
