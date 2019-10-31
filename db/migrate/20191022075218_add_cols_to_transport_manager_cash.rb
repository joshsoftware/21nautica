class AddColsToTransportManagerCash < ActiveRecord::Migration
  def change
    add_column :transport_manager_cashes, :date, :date
  end
end
