class AddColumnRemarksToImport < ActiveRecord::Migration
  def change
    add_column :imports, :remarks ,:string
  end
end
