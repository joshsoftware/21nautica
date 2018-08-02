class CreateMechanics < ActiveRecord::Migration
  def change
    create_table :mechanics do |t|
      t.string :name
      t.date :date_of_employment
      t.string :designation
      t.float :salary

      t.timestamps
    end
  end
end
