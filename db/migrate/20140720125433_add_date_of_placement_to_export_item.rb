class AddDateOfPlacementToExportItem < ActiveRecord::Migration
  def change
    add_column :export_items, :date_of_placement, :date
  end
end
