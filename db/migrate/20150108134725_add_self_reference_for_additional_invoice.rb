class AddSelfReferenceForAdditionalInvoice < ActiveRecord::Migration
  def change
  	add_column :invoices, :previous_invoice_id, :integer
  end
end
