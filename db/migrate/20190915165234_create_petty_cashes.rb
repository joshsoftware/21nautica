class CreatePettyCashes < ActiveRecord::Migration
  def change
    create_table :petty_cashes do |t|
      t.date :date
      t.text :description
      t.string :transaction_type
      t.float :transaction_amount 
      t.float :available_balance     
      t.timestamps
    end
  end
end
