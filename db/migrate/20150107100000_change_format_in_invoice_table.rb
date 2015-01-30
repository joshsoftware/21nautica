class ChangeFormatInInvoiceTable < ActiveRecord::Migration
  def change
  	change_column :invoices, :number, :string
  	change_column :invoices, :document_number, :string
  end
end
