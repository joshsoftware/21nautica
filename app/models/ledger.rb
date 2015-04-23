class Ledger < ActiveRecord::Base
  belongs_to :customer
  belongs_to :voucher, polymorphic: true

  def as_json(options={})
    super(only: [:voucher_type, :amount, :received, :date], methods: [:bl_number, :invoice_number])
  end

  def bl_number
    return self.voucher.invoiceable.bl_number if self.voucher_type == "Invoice"
    ""
  end

  def invoice_number
    return self.voucher.number if self.voucher_type == "Invoice"
    self.voucher.reference    
  end
end
