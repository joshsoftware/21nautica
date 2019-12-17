class AddColsToSparePart < ActiveRecord::Migration
  def change
    add_column :spare_parts, :parent_id, :integer
    add_column :spare_parts, :is_parent, :boolean
    add_column :req_parts, :original_id, :integer
    add_column :purchase_order_items, :original_id, :integer
  end
end
