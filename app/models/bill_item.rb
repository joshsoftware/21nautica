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
  validates :rate, :numericality => { :greater_than => 0 }

  #validates_associated :bill
  #if validation is not comment it results into infinite loop

  validates :item_for, inclusion: {in: %w(bl container)}
  validates :item_type, inclusion: {in: %w(Import Export)}

  validate :bl_check_total_quantity

  before_save :assigns_bill_items, :strip_whitespaces

  def assigns_bill_items
    self.bill_date = self.bill.bill_date
    self.vendor_id = self.bill.vendor_id
  end

  def is_bill_invoice_ugx?
    return true if self.bill.currency == 'UGX'
    return false
  end

  def bl_check_total_quantity
    return if ENV['HOSTNAME'] == 'RFS'
    case self.item_type
    when 'Import'
      if self.item_for == 'container'
        #container
        self.errors.add(:charge_for, "Container already charged") if BillItem.where(activity_id: self.activity_id, activity_type: 'Import', 
                                      charge_for: self.charge_for).where("lower(item_number) = ?", self.item_number.squish.downcase).where.not(id: self.id).exists?
      end
      import_qty = self.activity.quantity
      billed_qty = BillItem.where(activity_id: self.activity_id, charge_for: self.charge_for, activity_type: 'Import').where.not(id: self.id).sum(:quantity)
      self.errors.add(:quantity, "Total charged qty exceeds Import BL qty") if import_qty < (billed_qty + self.quantity)
    when 'Export'
      if self.item_for == 'container'
        #container
        self.errors.add(:charge_for, "Container already charged") if BillItem.where(activity_id: self.activity_id, activity_type: 'Export', 
                        charge_for: self.charge_for).where("lower(item_number) = ?", self.item_number.downcase).where.not(id: self.id).exists?
      end
      if self.item_for == 'container'
        bl_number = ExportItem.where("lower(container) = ?", self.item_number.squish.downcase).first.movement.bl_number
        if self.activity.export_type == 'TBL' and bl_number.nil?
          self.errors.add(:item_number, "BL not assigned, cannot create bill") 
          return
        end
        export_qty = Movement.where(bl_number: bl_number).count
      else
        export_qty = Movement.where(bl_number: self.item_number).count
      end
      billed_qty = BillItem.where(activity_id: self.activity_id, charge_for: self.charge_for, activity_type: 'Export').where.not(id: self.id).sum(:quantity)
      self.errors.add(:quantity, "Total charged qty exceeds Export qty") if export_qty < (billed_qty + self.quantity)

    end
  end

  def strip_whitespaces
    self.item_number = item_number.squish
  end

end
