class AddShipperToImports < ActiveRecord::Migration
  def change
    add_column :imports, :shippers, :string
  end
end
