class AddLocationInLocationDates < ActiveRecord::Migration
  def change
    add_column :location_dates, :location, :string
  end
end
