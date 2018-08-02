class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :type_of
      t.string :reg_number
      t.date :year_of_purchase
      t.date :insurance_expiry

      t.timestamps
    end
  end
end
