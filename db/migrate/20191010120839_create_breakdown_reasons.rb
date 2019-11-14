# frozen_string_literal: true

class CreateBreakdownReasons < ActiveRecord::Migration
  def change
    create_table :breakdown_reasons do |t|
      t.string :name
      t.timestamps
    end
  end
end
