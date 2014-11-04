class AddFieldsToMovement < ActiveRecord::Migration
  def change
    change_table :movements do |t|
      t.string :clearing_agent
      t.string :clearing_agent_payment
      t.string :transporter_payment
    end
  end
end
