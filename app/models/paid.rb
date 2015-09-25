class Paid < Payment
  belongs_to :vendor
  validates_presence_of :vendor_id

  has_one :vendor_ledger, as: :voucher, dependent: :destroy

  after_create do |record|
    record.update_ledger 
  end

  def update_ledger
    self.create_vendor_ledger(amount: self.amount, vendor: self.vendor, date: self.date_of_payment)
  end

end
