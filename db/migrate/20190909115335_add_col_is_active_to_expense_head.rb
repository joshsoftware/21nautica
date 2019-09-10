class AddColIsActiveToExpenseHead < ActiveRecord::Migration
  def change
    add_column :expense_heads, :is_active, :boolean
  end
end
