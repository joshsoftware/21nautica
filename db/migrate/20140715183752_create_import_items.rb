class CreateImportItems < ActiveRecord::Migration
  def change
    create_table :import_items do |t|
      t.string :container_number
      t.string :trailer_number
      t.string :tr_code
      t.string :truck_number
      t.string :current_location
      t.string :bond_direction
      t.string :bond_number
      t.string :status
      t.integer :import_id
      t.timestamps
    end
  end
end
