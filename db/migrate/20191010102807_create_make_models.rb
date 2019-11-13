class CreateMakeModels < ActiveRecord::Migration
  def change
    create_table :make_models do |t|
      t.string :name
      t.timestamps
    end
  end
end
