class CreateFuelManagements < ActiveRecord::Migration
  def change
    create_table :fuel_managements do |t|
      t.float :quantity
      t.float :cost
      t.date :date
      t.float :available
      t.boolean :is_adjustment
      t.references :truck, index: true
      t.string :vehicle_number
      t.string :purchased_dispensed

      t.timestamps
    end
  end
end
