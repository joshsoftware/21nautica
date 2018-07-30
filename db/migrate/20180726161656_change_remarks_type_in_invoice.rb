class ChangeRemarksTypeInInvoice < ActiveRecord::Migration
  def change
    change_column :invoices, :remarks, :text
  end
end
