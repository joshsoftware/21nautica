class AddIcdIdToImportItems < ActiveRecord::Migration
  def change
    add_column :import_items, :icd_id, :integer
  end
end
