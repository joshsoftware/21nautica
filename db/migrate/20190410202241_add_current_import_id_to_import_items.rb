class AddCurrentImportIdToImportItems < ActiveRecord::Migration
  def change
    add_column :trucks, :current_import_item_id, :integer
  end
end
