# == Schema Information
# Table name: debit_notes 
#
#  id            :integer      not null, primary key
#  bill_id       :integer
#  reason        :string
#  vendor_id     :integer
#  amount        :float
#  currency      :string
class DebitNote < ActiveRecord::Base
  belongs_to :bill
  belongs_to :vendor
  
  has_one :vendor_ledger, as: :voucher, dependent: :destroy

  validates_presence_of :amount, :reason, :vendor_id
  validates_associated :vendor

  after_save :create_vendor_ledger_debit_note

  def create_vendor_ledger_debit_note
    self.vendor_ledger.nil? ? self.create_vendor_ledger(vendor_id: vendor_id, amount: amount, date: self.bill.bill_date, 
                                                        currency: self.bill.currency) : 
      vendor_ledger.update_attributes(vendor_id: vendor_id, date: self.bill.bill_date, amount: amount, currency: self.bill.currency)
  end

end
