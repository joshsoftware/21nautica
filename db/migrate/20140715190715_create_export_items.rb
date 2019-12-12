# frozen_string_literal: true

class CreateExportItems < ActiveRecord::Migration
  def change
    create_table :export_items do |t|
      t.string :container
      t.string :location
      t.string :weight
      t.integer :export_id
      t.integer :movement_id
      t.timestamps
    end
  end
end
