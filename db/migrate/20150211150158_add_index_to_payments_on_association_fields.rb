# frozen_string_literal: true

class AddIndexToPaymentsOnAssociationFields < ActiveRecord::Migration
  def change
    add_index :payments, :customer_id
    add_index :payments, :vendor_id
  end
end
