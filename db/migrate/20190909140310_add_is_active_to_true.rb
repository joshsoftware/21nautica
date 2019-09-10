class AddIsActiveToTrue < ActiveRecord::Migration
  def change
    change_column_default(:expense_heads, :is_active, true)
  end
end
