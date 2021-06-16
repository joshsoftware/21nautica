class AddEquipmentToImportItem < ActiveRecord::Migration
  def change
    add_column :import_items, :equipment, :string
  end
end
