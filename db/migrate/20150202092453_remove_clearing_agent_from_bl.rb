class RemoveClearingAgentFromBl < ActiveRecord::Migration
  def change
    remove_column :bill_of_ladings, :clearing_agent
  end
end
