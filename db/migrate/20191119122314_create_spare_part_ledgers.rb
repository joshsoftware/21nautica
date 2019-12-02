class CreateSparePartLedgers < ActiveRecord::Migration
  def change
    create_table :spare_part_ledgers do |t|
      t.date :date
      t.integer :spare_part_id
      t.integer :quantity
      t.string :inward_outward
      t.string :receipt_type
      t.integer :receipt_id
      t.boolean :is_adjustment
      t.integer :balance

      t.timestamps
    end
  end
end
