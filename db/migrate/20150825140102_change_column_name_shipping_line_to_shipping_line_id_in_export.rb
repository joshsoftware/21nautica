class ChangeColumnNameShippingLineToShippingLineIdInExport < ActiveRecord::Migration
  def change
    rename_column :exports, :shipping_line, :shipping_line_name
  end
end
