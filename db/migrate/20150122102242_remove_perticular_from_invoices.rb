# frozen_string_literal: true

class RemovePerticularFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :perticular, :string
  end
end
