class CreateImportExpenses < ActiveRecord::Migration
  def change
    create_table :import_expenses do |t|
      t.references :import_item

      t.string :category
      t.string :name
      t.string :amount
      t.string :currency
      t.string :invoice_date
      t.string :delivery_date

      t.timestamps
    end
  end
end
