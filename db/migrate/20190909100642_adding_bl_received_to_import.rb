# frozen_string_literal: true

class AddingBlReceivedToImport < ActiveRecord::Migration
  def change
    add_column :imports, :bl_received_type, :integer
  end
end
