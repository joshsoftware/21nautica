# frozen_string_literal: true

class AddingImportTrackingColumnsToImportItemTable < ActiveRecord::Migration
  def change
    add_column :import_items, :exit_note_received , :boolean, default: false
    add_column :import_items, :dropped_location , :string
    add_column :import_items, :return_status , :string
    add_column :import_items, :expiry_date , :date
    add_column :import_items, :is_co_loaded , :boolean, :default => false
  end
end
