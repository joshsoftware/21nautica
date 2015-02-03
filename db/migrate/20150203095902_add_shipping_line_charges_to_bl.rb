class AddShippingLineChargesToBl < ActiveRecord::Migration
  def change
  	add_column :bill_of_ladings, :shipping_line_charges, :string
  end
end
