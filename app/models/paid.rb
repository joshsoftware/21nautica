class Paid < Payment
  belongs_to :vendor
  validates_presence_of :vendor_id

  has_one :vendor_ledger, as: :voucher, dependent: :destroy

  after_create do |record|
    record.update_ledger 
  end

  def update_ledger
    self.create_vendor_ledger(amount: self.amount, vendor: self.vendor, date: self.date_of_payment, currency: self.currency)

    bill = VendorLedger.where(voucher_type: "Bill", vendor: self.vendor, currency: self.currency).where("amount > paid").order(date: :asc,id: :asc)

    money = self.amount
    bill.each do |payment|
      return if money == 0

      if money - (payment.amount - payment.paid) > 0

        money -= (payment.amount - payment.paid)
        self.vendor_ledger.update_attribute(:paid, (payment.amount - payment.paid))
        payment.paid = payment.amount
      else

        payment.paid = payment.paid + money
        self.vendor_ledger.update_attribute(:paid, self.amount)
        money = 0
      end

      payment.save
    end
  end

end
