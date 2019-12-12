# frozen_string_literal: true

class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :imports, :shippers, :shipper
  end
end
