# frozen_string_literal: true

class CreateFuelStocks < ActiveRecord::Migration
  def change
    create_table :fuel_stocks do |t|
      t.float :quantity
      t.float :rate
      t.date :date
      t.float :balance

      t.timestamps
    end
  end
end
