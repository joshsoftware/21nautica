class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :number
      t.date :date
      t.integer :document_number
      t.integer :amount
      t.string :status
      t.integer :customer_id
      t.integer :bill_of_lading_id

      t.timestamps
    end
  end
end
