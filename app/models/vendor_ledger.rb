class VendorLedger < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :voucher, polymorphic: true

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

end
