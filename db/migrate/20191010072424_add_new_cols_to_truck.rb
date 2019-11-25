class AddNewColsToTruck < ActiveRecord::Migration
  def change
    add_column :trucks, :fuel_capacity, :integer 
    add_column :trucks, :trailer_reg_number, :string
    add_column :trucks, :insurance_premium_amt_yearly, :decimal , precision: 10, scale: 2
    add_column :trucks, :driver_name, :string, :limit =>50
    add_reference :trucks, :make_model, index: true 
  end
end
