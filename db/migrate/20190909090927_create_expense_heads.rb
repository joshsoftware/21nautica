class CreateExpenseHeads < ActiveRecord::Migration
  def change
    create_table :expense_heads do |t|
      t.string :name
      t.boolean :is_related_to_truck
      t.boolean :is_active, :default => true 
      t.timestamps
    end
  end
end
