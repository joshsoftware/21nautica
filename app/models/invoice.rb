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

  def additional_invoice_button
    self.previous_invoice.present? ? "<span class=\"badge\" id=\"additional_inv\" > Refs: #{self.previous_invoice.number} </span>" : 
    "<a class= \"btn btn-primary\" id=\"additional_inv\" href= \"/invoices/#{self.id}/add-additional-invoice\" data-remote=\"true\" > Additional INV </a>"
  end

  def is_additional_invoice?
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

  def container_data
    if (self.is_additional_invoice?)# this is additional invoice
      pick_up, destination, equipment = self.previous_invoice.container_data
    elsif self.is_import_invoice?
      import = self.invoiceable.import
      pick_up = import.from
      destination = import.to
      equipment = import.equipment
    elsif self.is_Haulage_export_invoice?
      movement = self.invoiceable
      pick_up = movement.port_of_loading
      destination = movement.port_of_discharge
      equipment = movement.equipment_type
    elsif self.is_TBL_export_invoice?
      movement = self.invoiceable.movements.first
      pick_up = movement.port_of_loading
      destination = movement.port_of_discharge
      equipment = movement.export_item.export.equipment
    end
    return pick_up, destination, equipment
  end

  def as_json(options={})
    super(methods: [:bl_number, :customer_name, :index_row_class, 
      :send_button_status, :total_containers, :update_button_status, 
      :additional_invoice_button])
  end
end
