class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|
      t.belongs_to :customer
      t.references :voucher, polymorphic: true
      t.integer :amount
      t.integer :received 
      t.date :date

      t.timestamps
    end
  end
end
