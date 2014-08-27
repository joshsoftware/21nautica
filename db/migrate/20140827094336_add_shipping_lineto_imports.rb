class AddShippingLinetoImports < ActiveRecord::Migration
  def change
    add_column :imports, :shipping_line ,:string
  end
end
