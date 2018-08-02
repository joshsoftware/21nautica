class CreateReqParts < ActiveRecord::Migration
  def change
    create_table :req_parts do |t|
      t.references :spare_part, index: true
      t.text :description
      t.references :mechanic, index: true
      t.float :price
      t.integer :quantity
      t.float :total_cost
      t.references :req_sheet, index: true

      t.timestamps
    end
  end
end
