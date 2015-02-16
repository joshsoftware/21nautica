class AddIndexToImportsAndMovementsOnClearingAgent < ActiveRecord::Migration
  def change
    add_index :imports, :clearing_agent_id
    add_index :movements, :clearing_agent_id 
  end
end
