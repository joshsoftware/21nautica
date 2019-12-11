class CreateFuelEntries < ActiveRecord::Migration
  def change
    create_table :fuel_entries do |t|
      t.float :quantity
      t.float :cost
      t.date :date
      t.float :available
      t.boolean :is_adjustment
      t.references :truck, index: true
      t.string :office_vehicle
      t.string :purchased_dispensed

      t.timestamps
    end
  end
end
