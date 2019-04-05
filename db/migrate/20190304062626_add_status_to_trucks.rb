class AddStatusToTrucks < ActiveRecord::Migration
  def change
    add_column :trucks, :status, :string
    add_column :trucks, :location, :string
  end
end
