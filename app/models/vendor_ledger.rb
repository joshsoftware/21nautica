class VendorLedger < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :voucher, polymorphic: true

  def as_json(options={})
    super(only: [:voucher_type, :amount, :paid, :date])#, methods: [:bl_number, :invoice_number])
  end

end
