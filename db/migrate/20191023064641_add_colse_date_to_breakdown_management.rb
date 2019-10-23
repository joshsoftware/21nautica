class AddColseDateToBreakdownManagement < ActiveRecord::Migration
  def change
    add_column :breakdown_managements, :close_date, :date
  end
end
