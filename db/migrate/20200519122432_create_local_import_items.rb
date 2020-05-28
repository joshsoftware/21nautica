class CreateLocalImportItems < ActiveRecord::Migration
  def change
    create_table :local_import_items do |t|
      t.date        :offloading_date
      t.string      :container_number
      t.string      :status
      t.string      :truck
      t.belongs_to  :local_import, index: true
      t.timestamps
    end
  end
end
