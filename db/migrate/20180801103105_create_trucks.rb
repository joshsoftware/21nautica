class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :type
      t.string :reg_number

      t.timestamps
    end
  end
end
