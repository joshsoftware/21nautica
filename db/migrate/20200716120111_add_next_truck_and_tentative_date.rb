class AddNextTruckAndTentativeDate < ActiveRecord::Migration
  def change
    add_column :import_items, :tentative_truck_allocation, :date
    add_column :import_items, :next_truck_id, :integer
    add_index :import_items, :next_truck_id
    add_index :import_items, :tentative_truck_allocation
  end
end
