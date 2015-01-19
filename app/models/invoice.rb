class Invoice < ActiveRecord::Base
  include AASM

  belongs_to :customer
  belongs_to :invoiceable, polymorphic: true
  delegate :bl_number, to: :invoiceable, allow_nil: true
  has_many :additional_invoices, class_name: "Invoice", 
    foreign_key: "previous_invoice_id"
  belongs_to :previous_invoice, class_name: "Invoice"

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

  def is_additional_invoice?
    self.previous_invoice.present?
  end

  def as_json(options={})
    super(methods: [:bl_number, :customer_name, :index_row_class])
  end

  def calculate_amount
    invoice_parent = self.invoiceable
    if (invoice_parent.is_a?(BillOfLading) && !invoice_parent.is_export_bl?)
      charges = self.collect_import_invoice_data #import invoice
    elsif (invoice_parent.is_a?(BillOfLading) && invoice_parent.is_export_bl?)
      charges = self.collect_export_TBL_data #export TBL
    elsif (invoice_parent.is_a?(Movement))
      charges = self.collect_export_haulage_data  #"export Haulage"
    end
    amount = 0
    charges.each_value do |charge|
      charge.each do |value|
        amount += value.first.to_i * value.second.to_i
      end
    end
    amount
  end

  def collect_import_invoice_data
    bill_of_lading = self.invoiceable
    import = bill_of_lading.import
    expenses = []
    import.import_items.each do |item|
      expenses.push(item.import_expenses.where.not(amount: nil || ""))
    end
    expenses.flatten!
    payment_hash = {}
    expenses.each do |expense|
      (payment_hash[expense.category + " " + "charges"] ||= []).push(expense.amount)
    end
    payment_hash["ocean freight"] = [bill_of_lading.payment_ocean] unless bill_of_lading.payment_ocean.blank?
    payment_hash["clearing charges"] = [bill_of_lading.payment_clearing] unless bill_of_lading.payment_clearing.blank?
    format_payment_hash(payment_hash)
  end

  def collect_export_TBL_data
    bill_of_lading = self.invoiceable
    payment_hash = {}
    movements = bill_of_lading.movements.where("movements.transporter_payment IS NOT NULL OR movements.clearing_agent_payment IS NOT NULL")
    movements.each do |movement|
      (payment_hash["Haulage/trans payment"] ||= []).push(movement.transporter_payment)
      (payment_hash["Local clearing"] ||= []).push(movement.clearing_agent_payment)
    end
    payment_hash["ocean freight"] = [bill_of_lading.payment_ocean] unless bill_of_lading.payment_ocean.blank?
    format_payment_hash(payment_hash)
  end

  def collect_export_haulage_data
    movement = self.invoiceable
    payment_hash = {}
    payment_hash["Haulage/trans payment"] = [movement.transporter_payment] unless movement.transporter_payment.blank?
    payment_hash["Local clearing"] = [movement.clearing_agent_payment] unless movement.clearing_agent_payment.blank?
    format_payment_hash(payment_hash)
  end

  def format_payment_hash(payment_hash)
    formatted_hash = {}
    payment_hash.each do |k,v|
      v.compact!
      formatted_hash[k] = v.inject({}) {|h,x| h[x.to_s].nil? ? h[x.to_s] = 1 : h[x.to_s] += 1; h}
    end
    formatted_hash
  end

end
