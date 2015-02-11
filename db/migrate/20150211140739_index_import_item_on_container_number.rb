class IndexImportItemOnContainerNumber < ActiveRecord::Migration
  def change
  	add_index :import_items, :container_number
  end
end
