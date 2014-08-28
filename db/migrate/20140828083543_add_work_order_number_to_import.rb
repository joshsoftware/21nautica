class AddWorkOrderNumberToImport < ActiveRecord::Migration
  def change
    add_column :imports, :work_order_number ,:string
  end
end
