# frozen_string_literal: true

class AddIndexToBlNumber < ActiveRecord::Migration
  def change
    add_index :bill_of_ladings, :bl_number
  end
end
