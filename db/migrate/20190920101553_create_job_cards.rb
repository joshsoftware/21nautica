class CreateJobCards < ActiveRecord::Migration
  def change
    create_table :job_cards do |t|
      t.date :date
      t.integer :number
      t.references :truck
      t.references :created_by, class:'User' 
      t.timestamps
    end
  end
end
