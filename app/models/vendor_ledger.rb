class VendorLedger < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :voucher, polymorphic: true
  after_create :update_ledger_for_bill, if: :bill?
  after_create :update_ledger_for_payment, if: :payment_or_debit_note?

  def bill?
    voucher_type == 'Bill'
  end
  
  def payment_or_debit_note?
    voucher_type == 'Payment' || voucher_type == 'DebitNote'
  end

  def as_json(options={})
    super(only: [:voucher_type, :amount, :paid, :date, :currency, :id], methods: [:bill_number, :delete_bill_or_ledger])
  end

  def delete_bill_or_ledger
    if self.voucher_type == 'Bill'
      "#{self.voucher_type}/#{self.voucher.id}"
    elsif voucher_type == 'DebitNote'
      "#{self.voucher_type}/#{self.voucher.id}"
    else
      "#{self.voucher_type}/#{self.voucher.id}"
    end
  end

  def bill_number
    if self.voucher_type == 'Bill'
      self.voucher.bill_number
    elsif voucher_type == 'DebitNote'
      self.voucher.try(:bill).try(:bill_number)
    else
      "#{self.voucher.try(:mode_of_payment)}-#{self.voucher.try(:reference)}"
    end
  end

  def update_ledger_for_bill
    ledgers = VendorLedger.where(voucher_type: ["Payment", 'DebitNote'], vendor: self.vendor, currency: self.currency).where("amount > paid").order(date: :asc,id: :asc)
    adjust_ledger(ledgers)
  end

  def update_ledger_for_payment
    ledgers = VendorLedger.where(voucher_type: "Bill", vendor: self.vendor, currency: self.currency).where("amount > paid").order(date: :asc,id: :asc)
    adjust_ledger(ledgers)
  end

  def adjust_ledger(unpaid)
    money = self.amount

    unpaid.each do |inv|
      # return if money got over.
       pending_amt = inv.amount - inv.paid 
       if money > pending_amt
         money -= pending_amt
         inv.update_columns(paid: (inv.paid + pending_amt))

       else
         inv.paid = inv.paid + money
         inv.update_attribute(:paid, inv.paid)
         money = 0
       end
       break if money == 0
    end
    self.update_attribute(:paid, self.amount - money)
  end
end
