class AddIsAllContainerDelivered < ActiveRecord::Migration
  def change
    add_column :imports, :is_all_container_delivered, :boolean, :default => false 
  end
end
