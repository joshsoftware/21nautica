class RemoveCreatedOnFromBill < ActiveRecord::Migration
  def change
    remove_column :bills, :created_on, :datetime
  end
end
