class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string  :equipment
      t.integer :quantity
      t.string  :from
      t.string  :to
      t.string  :bl_number
      t.date    :estimate_arrival
      t.string  :description
      t.string  :rate
      t.string  :status
      t.date    :out_of_port_date
      t.integer :customer_id
      t.timestamps
    end
  end
end
