class AddLegacyBltoInvoices < ActiveRecord::Migration
  def change
  	add_column :invoices, :legacy_bl, :string
  end
end
