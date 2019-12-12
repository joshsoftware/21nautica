# frozen_string_literal: true

class AddBillOfLadingToImport < ActiveRecord::Migration
  def change
    add_column :imports, :bill_of_lading_id, :string
    add_column :movements, :bill_of_lading_id, :string
  end
end
