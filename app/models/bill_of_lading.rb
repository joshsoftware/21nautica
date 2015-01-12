class BillOfLading < ActiveRecord::Base
  has_one :import
  has_many :movements
  has_one :invoice
  validates_uniqueness_of :bl_number
  auditable only: [:payment_ocean, :cheque_ocean,
    :payment_clearing, :cheque_clearing, :updated_at]

  def is_export_bl?
    Import.where(bill_of_lading_id: self.id.to_s).blank?
  end

  def shipping_line
    self.import.try(&:shipping_line) || self.movements.first.try(&:shipping_seal)
  end

  def ready_TBL_export_invoice
    invoice_date = self.movements.minimum(:created_at)
    customer = self.movements.first.export_item.export.customer
    invoice = Invoice.create(date: invoice_date)
    invoice.bill_of_lading = self
    invoice.customer = customer
    invoice.invoice_ready!
  end

end
