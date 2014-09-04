class AddColumnsToImportItem < ActiveRecord::Migration
  def change
		add_column :import_items, :context, :string
	end
end
