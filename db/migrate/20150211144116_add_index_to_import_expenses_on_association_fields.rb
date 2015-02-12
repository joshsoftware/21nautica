class AddIndexToImportExpensesOnAssociationFields < ActiveRecord::Migration
  def change
  	add_index :import_expenses, :import_item_id
  end
end
