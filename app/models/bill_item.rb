# == Schema Information
#
# Table name: bill_items
#
#  id            :integer not_null, primary
#  serial_number :integer
#  bill_id       :integer
#  bill_date     :datetime
#  vendor_id     :integer
#  item_type     :string
#  item_number   :text
#  item_for      :string  default: 'bl'
#  charge_for    :text
#  quantity      :integer
#  rate          :float
#  line_amount   :float
#  activity_id   :integer
#  activity_type :string
#  created_at    :datetime
#  update_at     :datetime
#

class BillItem < ActiveRecord::Base
  belongs_to :bill
  belongs_to :vendor
  belongs_to :activity, polymorphic: true

  validates_presence_of :bill_date, :vendor_id, :quantity, :rate, :line_amount
  validates :charge_for, presence: true, allow_blank: false 
  validates_associated :bill
  validates :item_for, inclusion: {in: %w(bl container)}
  validates :item_type, inclusion: {in: %w(Import Export)}

end
