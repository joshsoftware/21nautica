class CreateJobCardDetails < ActiveRecord::Migration
  def change
    create_table :job_card_details do |t|
      t.references :repair_head
      t.text :description
      t.timestamps
      t.references :job_card
    end
  end
end
