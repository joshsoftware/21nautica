class Paid < Payment
  belongs_to :vendor
  validates_presence_of :vendor_id

  has_one :vendor_ledger, as: :voucher, dependent: :destroy

  after_create do |record|
    self.create_vendor_ledger(amount: self.amount, vendor: self.vendor, date: self.date_of_payment, currency: self.currency)
  end

  def report_json
    as_json(methods: [:vendor_name])
  end

  def vendor_name
    vendor.try(:name)
  end

end
