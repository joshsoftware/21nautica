class AddTypeFieldToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :vendor_type, :string
  end
end
