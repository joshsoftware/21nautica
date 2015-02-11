class AddIndexToExportsOnAssociationFields < ActiveRecord::Migration
  def change
  	add_index :exports, :customer_id
  end
end
