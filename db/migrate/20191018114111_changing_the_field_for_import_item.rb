class ChangingTheFieldForImportItem < ActiveRecord::Migration
  def change
    change_column :import_items, :return_status, 'integer USING CAST(return_status AS integer)'
  end
end
