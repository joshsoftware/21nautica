
class CreateRemarks < ActiveRecord::Migration
  def change
    create_table :remarks do |t|
      t.integer :category
      t.datetime :date
      t.string :remarkable_type
      t.integer :remarkable_id
      t.string :desc

      t.timestamps
    end
  end
end
