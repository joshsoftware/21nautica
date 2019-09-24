class AddManualToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :manual, :boolean, default: false
  end
end
