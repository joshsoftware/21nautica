class AddShipperToImports < ActiveRecord::Migration
  def change
    add_column :imports, :bl_received, :integer
  end
end
