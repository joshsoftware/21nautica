class AddingIndexes < ActiveRecord::Migration
  def change
    add_index :import_items, :truck_number
    add_index :import_items, :status
    add_index :import_items, :exit_note_received
    add_index :import_items, :is_co_loaded
    add_index :import_items, :expiry_date
    add_index :imports, :bl_received_at
    add_index :imports, :entry_type
    add_index :imports, :created_at
    add_index :imports, :bl_number
    add_index :breakdown_managements, :status
    add_index :breakdown_managements, :date
    add_index :trucks, :reg_number
    add_index :spare_parts, :product_name
    add_index :spare_parts, :is_parent
    add_index :req_sheets, :date
    add_index :remarks, [:remarkable_type, :remarkable_id]
    add_index :remarks, :date
    add_index :purchase_orders, :date
    add_index :petty_cashes, :account_type
    add_index :petty_cashes, :date
    add_index :payments, :type
    add_index :job_cards, :date
  end
end
