class BillOfLading < ActiveRecord::Base
  has_one :import
  has_many :movements
  has_one :invoice, as: :invoiceable
  validates_uniqueness_of :bl_number
  auditable only: [:payment_ocean, :cheque_ocean,
    :payment_clearing, :cheque_clearing, :updated_at]

  after_update :ready_TBL_export_invoice, if: (:is_export_bl? && :invoice_not_present?)

  def is_export_bl?
    Import.where(bill_of_lading_id: self.id.to_s).blank?
  end

  def shipping_line
    self.import.try(&:shipping_line) || self.movements.first.try(&:shipping_seal)
  end

  def invoice_not_present?
    self.invoice.blank?
  end

  def ready_TBL_export_invoice
    invoice_date = self.movements.minimum(:created_at)
    customer = self.movements.first.export_item.export.customer
    invoice = Invoice.create(date: invoice_date)
    invoice.invoiceable = self
    invoice.customer = customer
    invoice.invoice_ready!
  end

  def update_import_invoice_amount
    if self.invoice.present?
      invoice = self.invoice
      invoice.update_import_invoice_amount
    end
  end

end
