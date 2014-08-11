class ChangeCurrentLocationToRemarks < ActiveRecord::Migration
  def change
    rename_column :movements, :current_location, :remarks
  end
end
