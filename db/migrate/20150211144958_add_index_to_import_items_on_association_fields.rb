class AddIndexToImportItemsOnAssociationFields < ActiveRecord::Migration
  def change
    add_index :import_items, :import_id
    add_index :import_items, :vendor_id
  end
end
