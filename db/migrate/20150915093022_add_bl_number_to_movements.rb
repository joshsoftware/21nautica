class AddBlNumberToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :bl_number, :string
  end
end
