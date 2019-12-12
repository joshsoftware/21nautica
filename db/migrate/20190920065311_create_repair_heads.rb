# frozen_string_literal: true

class CreateRepairHeads < ActiveRecord::Migration
  def change
    create_table :repair_heads do |t|
      t.string :name
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
