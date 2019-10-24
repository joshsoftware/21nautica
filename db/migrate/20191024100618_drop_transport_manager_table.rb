class DropTransportManagerTable < ActiveRecord::Migration
  def change
    drop_table :transport_manager_cashes if TransportManagerCash.present?
  end
end
