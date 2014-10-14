class AddClearingAgentToImports < ActiveRecord::Migration
  def change
    add_column :imports, :clearing_agent ,:string
  end
end
