class AddFieldsInIdf < ActiveRecord::Migration
  def change
    add_column :local_imports, :country_of_origin, :string
    add_column :local_imports, :comesa, :boolean
    add_column :local_imports, :fob, :float
    add_column :local_imports, :fob_currency, :string
    add_column :local_imports, :freight, :float
    add_column :local_imports, :freight_currency, :string
    add_column :local_imports, :other_charges, :float
    add_column :local_imports, :other_currency, :string
    add_column :local_imports, :copy_documets_date, :date
    add_column :local_imports, :original_documents_date, :date
    change_column :local_imports, :shipper, :string
  end
end
