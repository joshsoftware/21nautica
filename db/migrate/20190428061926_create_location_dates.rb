class CreateLocationDates < ActiveRecord::Migration
  def change
    create_table :location_dates do |t|
      t.references :truck, index: true
      t.date :date

      t.timestamps
    end
  end
end
