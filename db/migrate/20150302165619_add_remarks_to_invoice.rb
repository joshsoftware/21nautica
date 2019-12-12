# frozen_string_literal: true

class AddRemarksToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :remarks, :string
  end
end
