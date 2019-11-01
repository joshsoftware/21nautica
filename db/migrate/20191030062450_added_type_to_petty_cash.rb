class AddedTypeToPettyCash < ActiveRecord::Migration
  def change
    add_column :petty_cashes, :account_type, :string
  end
end
