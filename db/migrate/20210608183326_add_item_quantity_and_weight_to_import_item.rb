class AddItemQuantityAndWeightToImportItem < ActiveRecord::Migration
  def change
    add_column :import_items, :item_quantity, :integer, default: 0
    add_column :import_items, :item_weight, :float, default: 0.0
  end
end
