# frozen_string_literal: true

class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.text :bill_number
      t.datetime :bill_date
      t.belongs_to :vendor
      t.float :value
      t.text :remark
      t.belongs_to :created_by
      t.datetime :created_on
      t.belongs_to :approved_by

      t.timestamps
    end
  end
end
