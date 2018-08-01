class CreateSpareParts < ActiveRecord::Migration
  def change
    create_table :spare_parts do |t|
      t.string :product_name
      t.text :description
      t.references :spart_part_category, index: true

      t.timestamps
    end
  end
end
