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
    super(only: [:voucher_type, :amount, :paid, :date], methods: [:bill_number])
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

    money = self.amount
    adjusted_ledger_amt = 0
  
    ledgers.each do |ledger|
      return if money == 0

      if money - (ledger.amount - ledger.paid) > 0

        money -= ledger.amount - ledger.paid
        adjusted_amt = ledger.amount - ledger.paid

        adjusted_ledger_amt += ledger.amount - ledger.paid 
        ledger.update_columns(paid: (ledger.paid + adjusted_amt))

        self.update_columns(paid: adjusted_ledger_amt)
      else

        ledger_paid = ledger.paid + money
        ledger.update_columns(paid: ledger_paid)

        self.update_columns(paid: self.amount)
        money = 0
      end
    end
  end

  def update_ledger_for_payment
    ledgers = VendorLedger.where(voucher_type: "Bill", vendor: self.vendor, currency: self.currency).where("amount > paid").order(date: :asc,id: :asc)

    money = self.amount
    ledgers.each do |ledger|
      return if money == 0

      if money - (ledger.amount - ledger.paid) > 0

        money -= ledger.amount - ledger.paid
        self.update_attributes(paid: (ledger.amount - ledger.paid))
        ledger.update_columns(paid: ledger.amount)
        #ledger.paid = ledger.amount
      else

        ledger_paid = ledger.paid + money
        ledger.update_columns(paid: ledger_paid)
        self.update_attributes(paid: self.amount)
        money = 0
      end

    end
  end
end
