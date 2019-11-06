# frozen_string_literal: true

class AddClearingAgentAssociationToImportAndMovement < ActiveRecord::Migration
  def change
    add_column :imports, :clearing_agent_id, :integer
    add_column :movements, :clearing_agent_id, :integer
  end
end
