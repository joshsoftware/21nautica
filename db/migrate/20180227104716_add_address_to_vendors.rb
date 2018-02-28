class AddAddressToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :address_to, :string
  end
end
