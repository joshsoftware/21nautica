class ChangeAgencyFeeColumnType < ActiveRecord::Migration
  def change
  	change_column :bill_of_ladings, :agency_fee, :string
  end
end
