class AddTransporterNameAndWoNumberToMovements < ActiveRecord::Migration
  def change
  	add_column :movements, :transporter_name, :string
  	add_column :movements, :w_o_number, :string
  end
end
