class AddIndexToExportItemOnAssociationFields < ActiveRecord::Migration
  def change
  	add_index :export_items, :export_id
  end
end
