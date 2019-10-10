class CreateTransportManagerCashes < ActiveRecord::Migration
  def change
    create_table :transport_manager_cashes do |t|
      t.integer :sr_number
      t.date  :transaction_date
      t.string :transaction_type
      t.decimal :transaction_amount, precision: 10, scale: 2    
      t.decimal :available_balance, precision: 10, scale: 2
      t.references :import
      t.references :import_item
      t.references :truck
      t.references :created_by, class:'User'
      t.timestamps
    end
  end
end
