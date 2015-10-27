class Ledger < ActiveRecord::Base
  belongs_to :customer
  belongs_to :voucher, polymorphic: true

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
    return self.voucher.number if self.voucher_type == "Invoice"
    self.voucher.reference    
  end
end
