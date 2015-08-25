class ChangeDateFormatInBill < ActiveRecord::Migration
  def change
  	reversible do |dir|
      change_table :bills do |t|
        dir.up   { t.change :bill_date, :date }
        dir.down { t.change :bill_date, :datetime }
      end
    end
  end
end
