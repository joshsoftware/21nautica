class BillOfLading < ActiveRecord::Base
  has_one :import
  has_many :movements
  has_many :invoices, as: :invoiceable
  validates_uniqueness_of :bl_number
  auditable only: [:payment_ocean, :cheque_ocean, :payment_clearing,
    :cheque_clearing, :agency_fee, :shipping_line_charges, :updated_at]

  after_update :ready_TBL_export_invoice, if: [:is_export_bl?, :invoice_not_present?]

  def is_export_bl?
    Import.where(bill_of_lading_id: self.id.to_s).blank?
  end

  def shipping_line
    self.import.try(&:shipping_line).try(:name) || self.movements.first.try(&:shipping_seal)
  end

  def invoice_not_present?
    self.invoices.blank?
  end

  def ready_TBL_export_invoice
    invoice_date = self.movements.minimum(:created_at)
    customer = self.movements.first.export_item.export.customer
    invoice = Invoice.create(date: invoice_date)
    invoice.invoiceable = self
    invoice.customer = customer
    invoice.document_number = self.movements.pluck(:w_o_number).join(",")
    invoice.invoice_ready!
  end

  def clearing_agent
    import.present? ? import.clearing_agent : (movements.blank? ? nil : movements.first.clearing_agent)
  end

  def customer_name
    self.movements.first.try(&:customer_name) || (self.import.present? ? self.import.customer.name : nil)
  end

  def quantity
    self.import.try(&:quantity) || self.movements.count
  end

  def equipment_type
    self.import.try(&:equipment) ||  self.movements.first.try(&:equipment_type)
  end

  def pick_up
    self.import.try(&:from) ||  self.movements.first.try(&:port_of_loading)
  end

  def destination
    self.import.try(&:to) ||  self.movements.first.try(&:port_of_discharge)
  end

end
