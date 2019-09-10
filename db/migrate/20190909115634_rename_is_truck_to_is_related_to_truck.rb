class RenameIsTruckToIsRelatedToTruck < ActiveRecord::Migration
  def change
    rename_column :expense_heads, :is_truck, :is_related_to_truck
  end
end
