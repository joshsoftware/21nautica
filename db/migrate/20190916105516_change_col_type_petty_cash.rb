class ChangeColTypePettyCash < ActiveRecord::Migration
  def change
  change_column :petty_cashes, :transaction_amount, :decimal, :precision => 20, :scale => 2
  change_column :petty_cashes, :available_balance, :decimal, :precision => 20, :scale => 2
  #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
