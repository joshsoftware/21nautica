class AddVendorIdToMovement < ActiveRecord::Migration
  def change
  	add_column :movements, :vendor_id, :integer
  	#remove_column :movements, :transporter_name, :string
  end
end
