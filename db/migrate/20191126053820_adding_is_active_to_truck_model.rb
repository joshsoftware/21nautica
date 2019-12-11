class AddingIsActiveToTruckModel < ActiveRecord::Migration
  def change
    add_column :trucks, :is_active, :boolean, default: :true
  end
end
