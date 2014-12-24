class RemoveTransporterName < ActiveRecord::Migration
  def change
  	remove_column :movements, :transporter_name, :string
  	remove_column :import_items, :transporter_name, :string
  end
end
