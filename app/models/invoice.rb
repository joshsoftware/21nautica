class Invoice < ActiveRecord::Base
  include AASM
  # include Remarkable
  
  validates_presence_of :customer
  belongs_to :customer
  belongs_to :invoiceable, polymorphic: true
  has_many :additional_invoices, class_name: "Invoice",
    foreign_key: "previous_invoice_id", dependent: :destroy
  belongs_to :previous_invoice, class_name: "Invoice"
  has_many :particulars, dependent: :destroy

  has_one :ledger, as: :voucher, dependent: :destroy

  accepts_nested_attributes_for :particulars, allow_destroy: true
  after_create :assign_parent_invoice_number, unless: :is_additional_invoice

  delegate :equipment_type, to: :invoiceable, allow_nil: true
  delegate :pick_up, to: :invoiceable, allow_nil: true
  delegate :destination, to: :invoiceable, allow_nil: true

  aasm column: 'status' do
    state :new, initial: true
    state :ready
    state :sent

    event :invoice_ready do
      transitions from: :new, to: :ready
    end

    event :invoice_sent, after: :update_ledger do
      transitions from: :ready, to: :sent
    end
  end

  class << self
    def merge_additional_invoices(invoices)
      additional_invoices = []
      invoices.each do |invoice|
        if invoice.previous_invoice.nil?
          additional_invoices << invoice
        else
          additional_invoices << invoice.previous_invoice
        end
      end
      additional_invoices.uniq
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

  def previous_invoice_number
    self.previous_invoice.try(:number)
  end

  def is_additional_invoice
    self.previous_invoice.present?
  end

  def is_import_invoice?
    self.invoiceable.is_a?(BillOfLading) && !self.invoiceable.is_export_bl?
  end

  def rate_agreed
    import = self.invoiceable.try(:import)
    import.rate_agreed unless import.blank?
  end

  def is_TBL_export_invoice?
    (self.invoiceable.is_a?(BillOfLading) && self.invoiceable.is_export_bl?)
  end

  def is_Haulage_export_invoice?
    self.invoiceable.is_a?(Movement)
  end

  def is_legacy_bl
    !self.legacy_bl.nil?
  end

  def total_containers
    #find total number of containers according to invoice type
    if is_import_invoice?
      import = self.invoiceable.import
      quantity = import.quantity
    elsif is_TBL_export_invoice?
      quantity = self.invoiceable.movements.count
    else
      quantity = 1
    end
  end

  def container_number
    # will be only available for haulage type of invoices
    self.invoiceable.container_number if is_Haulage_export_invoice?
  end

  def bl_number
    self.invoiceable.try(:bl_number) || self.legacy_bl
  end

  def bl_or_container_number
    self.bl_number || self.container_number || ""
  end

  def entry_number
    if invoiceable.is_a? BillOfLading
      invoiceable.import.entry_number
    end
  end

  def cargo_description
    if invoiceable.is_a? BillOfLading
      invoiceable.import.description
    end
  end

  def cargo_truck_numbers
    if invoiceable.is_a? BillOfLading
      invoiceable.import.import_items.pluck(:truck_number).join(', ')
    end
  end

  def as_json(options={})
    super(methods: [:bl_or_container_number, :customer_name, :index_row_class,
      :send_button_status, :total_containers, :update_button_status,
      :is_additional_invoice, :previous_invoice_number, :is_legacy_bl, :equipment_type, :formatted_date])
  end

  def assign_additional_invoice_number
    pervious_invoice = self.previous_invoice.number
    additional_invoice = self.previous_invoice.additional_invoices.last
    self.number = additional_invoice.blank? ? self.previous_invoice.number + "-a" : additional_invoice.number.next
  end

  def assign_parent_invoice_number
    date = Date.current.strftime("%m%Y%d")
    count = Invoice.where(previous_invoice_id: nil).where("created_at > ?", Date.current).count
    self.update_attributes(number: date + count.to_s)
  end

  # Only when the invoice is sent to the customer, we need to update the ledger. This is
  # required for the running accounts!
  def update_ledger
    self.create_ledger(amount: self.amount, customer: self.customer, date: self.date, received: 0)
  end

  def formatted_date
    date.try(:strftime, "%d-%m-%Y")
  end
end
