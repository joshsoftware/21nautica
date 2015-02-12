class AddIndexToParticularssOnAssociationFields < ActiveRecord::Migration
  def change
    add_index :particulars, :invoice_id
  end
end
