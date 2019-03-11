class AddTruckToImportItems < ActiveRecord::Migration
  def change
    add_reference :import_items, :truck, index: true
  end
end
