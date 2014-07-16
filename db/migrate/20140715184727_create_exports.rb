class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.string  :export_type
      t.string  :shipping_line
      t.integer :placed
      t.string  :release_order_number
      t.timestamps
    end
  end
end
