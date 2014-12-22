class AddVendorIdToImportItem < ActiveRecord::Migration
  def change
  	add_column :import_items, :vendor_id, :integer
  end
end
