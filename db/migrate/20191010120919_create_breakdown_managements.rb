class CreateBreakdownManagements < ActiveRecord::Migration
  def change
    create_table :breakdown_managements do |t|
      t.date :date
      t.text :remark
      t.string :location
      t.references :mechanic
      t.references :truck
      t.string :status
      t.boolean :parts_required
      t.date :sending_date
      t.references :breakdown_reason
      t.timestamps
    end
  end
end
