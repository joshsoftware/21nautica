class AddMovedColumntoExports < ActiveRecord::Migration
  def change
  	add_column :exports, :moved ,:string
  end
end
