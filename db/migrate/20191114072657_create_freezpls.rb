class CreateFreezpls < ActiveRecord::Migration
  def change
    create_table :freezpls do |t|
      t.date :date
      t.timestamps
    end
  end
end
