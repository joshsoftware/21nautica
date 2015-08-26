class RenameShippingLineToShippingLineName < ActiveRecord::Migration
  def change
    rename_column :imports, :shipping_line, :shipping_line_name
    add_column :imports, :shipping_line_id, :integer
  end
end
