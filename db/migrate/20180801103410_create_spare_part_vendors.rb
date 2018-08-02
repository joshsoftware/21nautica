class CreateSparePartVendors < ActiveRecord::Migration
  def change
    create_table :spare_part_vendors do |t|
      t.string :name
      t.string :address
      t.string :contact_person

      t.timestamps
    end
  end
end
