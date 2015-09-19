class CreateDebitNotes < ActiveRecord::Migration
  def change
    create_table :debit_notes do |t|
      t.string :reason
      t.float :amount
      t.references :bill, index: true
      t.references :vendor, index: true

      t.timestamps
    end
  end
end
