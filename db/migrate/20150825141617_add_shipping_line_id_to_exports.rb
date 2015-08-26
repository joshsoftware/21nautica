class AddShippingLineIdToExports < ActiveRecord::Migration
  def change
    add_column :exports, :shipping_line_id, :integer
  end
end
