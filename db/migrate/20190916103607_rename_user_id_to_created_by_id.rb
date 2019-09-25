class RenameUserIdToCreatedById < ActiveRecord::Migration
  def change
    rename_column :petty_cashes, :user_id, :created_by_id
  end
end
