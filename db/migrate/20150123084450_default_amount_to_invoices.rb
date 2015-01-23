class DefaultAmountToInvoices < ActiveRecord::Migration
  def change
  	change_column_default :invoices, :amount, 0
  end
end
