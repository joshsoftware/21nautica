# frozen_string_literal: true

class AddLastLoadingDateImportItems < ActiveRecord::Migration
  def change
    add_column :import_items, :last_loading_date, :datetime
  end
end
