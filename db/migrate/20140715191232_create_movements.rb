class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :booking_number
      t.string :truck_number
      t.string :vessel_targeted
      t.string :port_of_destination
      t.string :port_of_loading
      t.date   :estimate_delivery
      t.string :movement_type
      t.string :shipping_seal
      t.string :custom_seal
      t.string :current_location
      t.string :status
      t.timestamps
    end
  end
end
