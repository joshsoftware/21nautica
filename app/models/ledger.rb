class Ledger < ActiveRecord::Base
  belongs_to :customer
  belongs_to :voucher, polymorphic: true
  after_create :update_ledger_if_payment_made, if: :payment?
  after_create :update_ledger_if_invoice_made, if: :invoice?

  def payment?
    voucher_type == 'Payment'
  end

  def invoice?
    voucher_type == 'Invoice'
  end

  def update_ledger_if_payment_made
    unpaid = Ledger.where(voucher_type: "Invoice", customer: self.customer).where("received < amount").order(date: :asc)
    adjust_ledger(unpaid)
  end

  def update_ledger_if_invoice_made
    unpaid = Ledger.where(voucher_type: "Payment", customer: self.customer).where("received < amount").order(date: :asc)
    adjust_ledger(unpaid)
  end

  def adjust_ledger(unpaid)
    money = self.amount

    unpaid.each do |inv|
      # return if money got over.
       pending_amt = inv.amount - inv.received 
       if money > pending_amt
         money -= pending_amt
         inv.update_columns(received: (inv.received + pending_amt))
       else
         inv.received = inv.received + money
         inv.update_attribute(:received, inv.received)
         money = 0
       end
       break if money == 0
    end
    self.update_attribute(:received, self.amount - money)
  end

  def as_json(options={})
    super(only: [:voucher_type, :amount, :received, :date], methods: [:bl_number, :invoice_number, :delete_invoice_or_payment])
  end

  def delete_invoice_or_payment
    if self.voucher_type == 'Invoice'
      "#{self.voucher_type}/#{self.voucher.id}"
    else
      "#{self.voucher_type}/#{self.voucher.id}"
    end
  end

  def bl_number
    # older imported invoices may not have a bl_number!
    return self.voucher.invoiceable.try(:bl_number) if self.voucher_type == "Invoice"
  end

  def invoice_number
    return "#{voucher.number} (M)" if invoice? && voucher.manual?
    return self.voucher.number if self.voucher_type == "Invoice"
    self.voucher.reference    
  end
end
