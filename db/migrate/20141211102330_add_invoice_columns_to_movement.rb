class AddInvoiceColumnsToMovement < ActiveRecord::Migration
  def change
  	change_table :movements do |t|
      t.date :transporter_invoice_date
      t.string :transporter_invoice_number
      t.date :clearing_agent_invoice_date
      t.string :clearing_agent_invoice_number
    end
  end
end
