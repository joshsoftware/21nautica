# frozen_string_literal: true

class AddPolymorphicAssociationToInvoice < ActiveRecord::Migration
  def change
    remove_column :invoices, :bill_of_lading_id, :integer
    add_column :invoices, :invoiceable_id, :integer
    add_column :invoices, :invoiceable_type, :string
  end
end
