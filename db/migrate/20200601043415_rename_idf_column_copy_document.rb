class RenameIdfColumnCopyDocument < ActiveRecord::Migration
  def change
    rename_column :local_imports, :copy_documets_date, :copy_documents_date
  end
end
