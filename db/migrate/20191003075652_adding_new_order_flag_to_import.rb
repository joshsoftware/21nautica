class AddingNewOrderFlagToImport < ActiveRecord::Migration
  def change
    add_column :imports, :is_new_order, :boolean, :default => false
  end
end
