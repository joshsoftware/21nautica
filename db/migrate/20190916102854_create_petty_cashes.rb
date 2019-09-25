class CreatePettyCashes < ActiveRecord::Migration
  def change
    create_table :petty_cashes do |t|
      t.date :date
      t.text :description
      t.string :transaction_type
      t.decimal :transaction_amount, :precision => 15, :scale => 2
      t.decimal :available_balance, :precision => 15, :scale => 2     
      t.timestamps
    end
  end
end
