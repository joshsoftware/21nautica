class RenameRemarksToRemarkToAllTable < ActiveRecord::Migration
  def change
    # rename_column :invoices, :remarks, :remark
    # rename_column :movements, :remarks, :remark
    rename_column :imports, :remarks, :remark
    rename_column :import_items, :remarks, :remark
    # rename_column :bill_of_ladings, :remarks, :remark
    # rename_column :payments, :remarks, :remark
  end
end
