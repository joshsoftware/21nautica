# == Schema Information
# Table name: debit_notes 
#
#  id            :integer      not null, primary key
#  bill_id       :integer
#  reason        :string
#  vendor_id     :integer
#  amount        :float
#
class DebitNote < ActiveRecord::Base
  belongs_to :bill
  belongs_to :vendor
  
  has_one :vendor_ledger, as: :voucher

  validates_presence_of :amount, :reason
  validates_associated :vendor

  after_save :set_vendor_ledger

  def set_vendor_ledger
    self.vendor_ledger.nil? ? self.create_vendor_ledger(vendor_id: vendor_id, amount: amount, bill_date: self.bill.bill_date) : 
      vendor_ledger.update_attributes(vendor_id: vendor_id, bill_date: self.bill.bill_date, amount: amount)
  end

end
