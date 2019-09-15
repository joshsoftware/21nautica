class AddRefrencesToPettyCash < ActiveRecord::Migration
  def change
    add_reference :petty_cashes, :expense_head, index: true
    add_reference :petty_cashes, :truck, index: true
    add_reference :petty_cashes, :user, index: true 
  end
end
