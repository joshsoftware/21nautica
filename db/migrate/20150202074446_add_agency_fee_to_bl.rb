# frozen_string_literal: true

class AddAgencyFeeToBl < ActiveRecord::Migration
  def change
    add_column :bill_of_ladings, :agency_fee, :integer
  end
end
