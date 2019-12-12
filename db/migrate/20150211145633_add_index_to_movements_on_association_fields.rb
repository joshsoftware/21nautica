# frozen_string_literal: true

class AddIndexToMovementsOnAssociationFields < ActiveRecord::Migration
  def change
    add_index :movements, :bill_of_lading_id
    add_index :movements, :vendor_id
  end
end
