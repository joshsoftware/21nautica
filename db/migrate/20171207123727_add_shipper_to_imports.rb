# frozen_string_literal: true

class AddShipperToImports < ActiveRecord::Migration
  def change
    add_column :imports, :shippers, :integer
  end
end
