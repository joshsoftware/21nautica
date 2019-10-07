class AddingIsNewOrderFlagToImport < ActiveRecord::Migration
  def change
    add_column :imports, :new_import , :boolean, default: :false
  end
end
