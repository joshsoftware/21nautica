class Invoice < ActiveRecord::Base
  include AASM

  belongs_to :customer
  belongs_to :invoiceable, polymorphic: true
  delegate :bl_number, to: :invoiceable, allow_nil: true
  has_many :additional_invoices, class_name: "Invoice", 
    foreign_key: "previous_invoice_id"
  belongs_to :previous_invoice, class_name: "Invoice"
  has_many :invoice_perticulars

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
    self.customer.name
  end

  def index_row_class
    self.previous_invoice.present? ? "warning" : ""
  end

  def send_button_status
    self.new? ? "disabled" : ""
  end

  def is_additional_invoice?
    self.previous_invoice.present?
  end

  def as_json(options={})
    super(methods: [:bl_number, :customer_name, :index_row_class, :send_button_status])
  end
end
