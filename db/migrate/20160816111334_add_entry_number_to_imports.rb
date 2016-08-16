class AddEntryNumberToImports < ActiveRecord::Migration
  def change
    add_column :imports, :entry_number, :string
  end
end
