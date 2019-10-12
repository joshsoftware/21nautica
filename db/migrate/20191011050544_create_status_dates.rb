class CreateStatusDates < ActiveRecord::Migration
  def change
    create_table :status_dates do |t|
      t.date :under_loading_process
      t.date :truck_allocated
      t.date :loaded_out_of_port
      t.date :arrived_at_border
      t.date :departed_from_border
      t.date :arrived_at_destination
      t.date :delivered
      t.references :import_item

      t.timestamps
    end
  end
end
