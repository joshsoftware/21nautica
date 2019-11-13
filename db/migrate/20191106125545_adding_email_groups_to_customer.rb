class AddingEmailGroupsToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :account_emails, :string
    add_column :customers, :operation_emails, :string
    add_column :customers, :management_emails, :string
  end
end
