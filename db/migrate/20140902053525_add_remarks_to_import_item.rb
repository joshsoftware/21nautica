class AddRemarksToImportItem < ActiveRecord::Migration
  def change
    add_column :import_items, :remarks, :string
  end
end



