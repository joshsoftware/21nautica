class Invoice < ActiveRecord::Base
  include AASM

  belongs_to :customer
  belongs_to :invoiceable, polymorphic: true
  delegate :bl_number, to: :invoiceable, allow_nil: true
  has_many :additional_invoices, class_name: "Invoice", 
    foreign_key: "previous_invoice_id"
  belongs_to :previous_invoice, class_name: "Invoice"
  has_many :particulars
  accepts_nested_attributes_for :particulars, allow_destroy: true

  aasm column: 'status' do
    state :new, initial: true
    state :ready
    state :sent

    event :invoice_ready do
      transitions from: :new, to: :ready
    end

    event :invoice_sent do
      transitions from: :ready, to: :sent
    end
  end 

  def customer_name
    self.customer.try(:name)
  end

  def index_row_class
    self.previous_invoice.present? ? "warning" : ""
  end

  def send_button_status
    self.new? ? "disabled" : ""
  end

  def update_button_status
    self.sent? ? "disabled" : ""
  end

  def additional_invoice_button_link
    self.previous_invoice.present? ? "/invoices/#{self.previous_invoice.id}/download.pdf" :
     "/invoices/#{self.id}/new-additional-invoice"
  end

  def additional_invoice_button_text
    self.previous_invoice.present? ? "Refs Inv: #{self.previous_invoice.number}" : "Additional INV"
  end

  def is_additional_invoice?
    self.previous_invoice.present?
  end

  def total_containers
    #find total number of containers according to invoice type
    if self.invoiceable.is_a?(BillOfLading) && !self.invoiceable.is_export_bl?
      import = self.invoiceable.import
      quantity = import.quantity
    elsif (self.invoiceable.is_a?(BillOfLading) && self.invoiceable.is_export_bl?)
      quantity = self.invoiceable.movements.count
    else
      quantity = 1
    end
  end

  def as_json(options={})
    super(methods: [:bl_number, :customer_name, :index_row_class, 
      :send_button_status, :total_containers, :update_button_status, 
      :additional_invoice_button_link, :additional_invoice_button_text])
  end
end
