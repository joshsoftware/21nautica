class AddRateAgreedAndWeightFieldToImport < ActiveRecord::Migration
  def change
    add_column :imports, :rate_agreed, :string
    add_column :imports, :weight, :string
  end
end
