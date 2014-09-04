class AddNewColumnsToImportItem < ActiveRecord::Migration
  def change
  	add_column :import_items, :yard_name, :string
  	add_column :import_items, :g_f_expiry, :datetime
  	add_column :import_items, :close_date, :datetime
  	add_column :import_items, :after_delivery_status, :string
  end
end
