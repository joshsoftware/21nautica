class CreateExpenseHeads < ActiveRecord::Migration
  def change
    create_table :expense_heads do |t|
      t.string :name
      t.boolean :is_truck
      t.timestamps
    end
  end
end
