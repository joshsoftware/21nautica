class AddIndexToImportsOnAssociationFields < ActiveRecord::Migration
  def change
  	add_index :imports, :customer_id
  	add_index :imports, :bill_of_lading_id
  end
end
