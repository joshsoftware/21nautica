class AddSalesRepNameToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :sales_rep_name, :string
  end
end
