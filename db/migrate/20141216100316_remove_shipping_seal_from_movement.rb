class RemoveShippingSealFromMovement < ActiveRecord::Migration
  def change
    remove_column :movements, :shipping_seal, :string
  end
end
