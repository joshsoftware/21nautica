class CreateInvoicePerticulars < ActiveRecord::Migration
  def change
    create_table :invoice_perticulars do |t|
      t.references :invoice
      t.string :name
      t.integer :rate
      t.integer :quantity
      t.integer :subtotal, default: 0

      t.timestamps
    end
  end
end
