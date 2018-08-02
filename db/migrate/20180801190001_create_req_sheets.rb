class CreateReqSheets < ActiveRecord::Migration
  def change
    create_table :req_sheets do |t|
      t.string :ref_number
      t.date :date
      t.float :value

      t.timestamps
    end
  end
end
