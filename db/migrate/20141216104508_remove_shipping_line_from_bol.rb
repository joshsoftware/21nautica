class RemoveShippingLineFromBol < ActiveRecord::Migration
  def change
    remove_column :bill_of_ladings, :shipping_line, :string
  end
end
