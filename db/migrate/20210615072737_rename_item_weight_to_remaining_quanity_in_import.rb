class RenameItemWeightToRemainingQuanityInImport < ActiveRecord::Migration
  def change
    rename_column :imports, :item_weight, :remaining_quantity
  end
end
