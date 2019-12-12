# frozen_string_literal: true

class CreateSpareParts < ActiveRecord::Migration
  def change
    create_table :spare_parts do |t|
      t.string :product_name
      t.text :description
      t.references :spare_part_category, index: true
      t.references :spare_part_sub_category

      t.timestamps
    end
  end
end
