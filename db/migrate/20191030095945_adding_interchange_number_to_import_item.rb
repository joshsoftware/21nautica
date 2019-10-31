class AddingInterchangeNumberToImportItem < ActiveRecord::Migration
  def change
    add_column :import_items, :interchange_number, :string
  end
end
