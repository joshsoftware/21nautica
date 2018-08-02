class CreateSparePartCategories < ActiveRecord::Migration
  def change
    create_table :spare_part_categories do |t|
      t.string :name
      t.references  :sub_category, foreign_key: { to_table: :spare_part_categories }, index: false

      t.timestamps
    end
  end
end
