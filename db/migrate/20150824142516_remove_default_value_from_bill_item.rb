# frozen_string_literal: true

class RemoveDefaultValueFromBillItem < ActiveRecord::Migration
  def up
    change_column_default(:bill_items, :item_for, nil)
  end

  def down
    change_column_default(:bill_items, :item_for, "bl")
  end
end
