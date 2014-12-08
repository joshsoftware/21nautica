class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :participants_name
      t.date :date_of_payment
      t.integer :amount
      t.string :mode_of_payment
      t.string :reference
      t.string :remarks
      t.string :type

      t.timestamps
    end
  end
end
