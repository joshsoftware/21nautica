class AddingEntryDateToImport < ActiveRecord::Migration
  def change
    add_column :imports, :entry_date, :date
  end
end
