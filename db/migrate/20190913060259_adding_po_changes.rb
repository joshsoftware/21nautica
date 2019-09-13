class AddingPoChanges < ActiveRecord::Migration
  def change
    add_column :imports, :bl_received_at, :date
    add_column :imports, :charges_received_at, :date
    add_column :imports, :charges_paid_at, :date
    add_column :imports, :do_received_at, :date
    add_column :imports, :pl_received_at, :date
    add_column :imports, :gf_return_date, :date
    add_column :imports, :return_location, :string
    add_column :imports, :is_late_submission, :boolean
    add_column :imports, :rotation_number, :string
    # add_column :imports, :entry_number, :string - Already exists
    add_column :imports, :entry_type, :integer
  end
end
