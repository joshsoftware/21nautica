class RemoveIcdIdFromImportItems < ActiveRecord::Migration
  def change
    remove_column :import_items, :icd_id
  end
end
