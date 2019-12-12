# frozen_string_literal: true

class ChangeMovementPortOfDestination < ActiveRecord::Migration
  def change
    rename_column :movements, :port_of_destination, :port_of_discharge
  end
end
