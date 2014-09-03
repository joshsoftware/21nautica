class AddTransporterToImportItem < ActiveRecord::Migration
  def change
  	add_column :import_items, :transporter_name, :string
  end
end
