class AddPerticularToInvoice < ActiveRecord::Migration
  def change
  	add_column :invoices, :perticular, :string
  end
end
