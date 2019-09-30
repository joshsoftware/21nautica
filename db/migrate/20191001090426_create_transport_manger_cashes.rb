class CreateTransportMangerCashes < ActiveRecord::Migration
  def change
    create_table :transport_manger_cashes do |t|
      t.integer :sr_number
      t.date  :transaction_date
      t.string :transaction_type
      t.decimal :transaction_amount, precision: 10, scale: 2    
      t.decimal :available_balance, precision: 10, scale: 2
      t.string :truck_number
      t.references :import
      t.references :import_item
      t.references :truck
      t.references :user, foreign_key: 'created_by'
      t.timestamps
    end
  end
end
