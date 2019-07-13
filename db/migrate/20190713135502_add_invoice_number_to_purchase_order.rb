class AddInvoiceNumberToPurchaseOrder < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :inv_number, :string
    add_column :purchase_orders, :inv_date, :date
  end
end
