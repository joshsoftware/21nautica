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

  validates_presence_of :quantity, :rate, :line_amount
  #bill_date & vendor_id asssign after save bill

  validates :charge_for, presence: true, allow_blank: false 

  #validates_associated :bill
  #if validation is not comment it results into infinite loop

  validates :item_for, inclusion: {in: %w(bl container)}
  validates :item_type, inclusion: {in: %w(Import Export)}

  validate :bl_check_total_quantity

  before_save :assigns_bill_items

  def assigns_bill_items
    self.bill_date = self.bill.bill_date
    self.vendor_id = self.bill.vendor_id
  end

  def bl_check_total_quantity
    case self.item_type
    when 'Import'
      if self.item_for == 'bl'
        import_qty = self.activity.quantity
        billed_qty = BillItem.where(activity_id: self.activity_id, charge_for: self.charge_for).sum(:quantity)
        self.errors.add(:quantity, "must be less than import") if import_qty < (billed_qty + self.quantity)
      else
        #container
        #
      end
    end
  end

end
