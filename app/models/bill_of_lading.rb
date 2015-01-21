class BillOfLading < ActiveRecord::Base
  has_one :import
  has_many :movements
  has_one :invoice, as: :invoiceable
  validates_uniqueness_of :bl_number
  auditable only: [:payment_ocean, :cheque_ocean,
    :payment_clearing, :cheque_clearing, :updated_at]

  after_update :update_import_invoice_amount, unless: :is_export_bl?
  after_update :update_export_TBL_invoice_amount, if: :is_export_bl?

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

  def update_export_TBL_invoice_amount
    if self.invoice.present?
      invoice = self.invoice
      invoice.update_TBL_invoice_amount
    end
  end

end
