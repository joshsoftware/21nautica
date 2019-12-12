# frozen_string_literal: true

class AddingTripDateToStatusDates < ActiveRecord::Migration
  def change
    add_column :status_dates, :trip_date, :date
  end
end
