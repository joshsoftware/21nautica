class AddingConsigneeNameToImport < ActiveRecord::Migration
  def change
  	add_column :imports, :consignee_name, :string
  end
end
