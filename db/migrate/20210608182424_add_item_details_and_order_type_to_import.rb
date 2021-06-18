class AddItemDetailsAndOrderTypeToImport < ActiveRecord::Migration
  def change
    add_column :imports, :item_quantity, :integer, default: 1
    add_column :imports, :item_weight, :float, default: 0.0
    add_column :imports, :remaining_weight, :float, default: 0.0
    add_column :imports, :order_type, :string, default: "Normal"
  end
end
