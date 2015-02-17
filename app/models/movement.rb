# == Schema Information
#
# Table name: movements
#
#  id                   :integer          not null, primary key
#  booking_number       :string(255)
#  truck_number         :string(255)
#  vessel_targeted      :string(255)
#  port_of_discharge :string(255)
#  port_of_loading     :string(255)
#  estimate_delivery    :date
#  movement_type        :string(255)
#  shipping_seal        :string(255)
#  custom_seal          :string(255)
#  remarks              :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  transporter_name     :string(255)
#  w_o_number           :string(255)
#

class Movement < ActiveRecord::Base
  include AASM
  include MovementsHelper

  has_one :export_item
  belongs_to :bill_of_lading
  belongs_to :transporter, class_name: "Vendor", foreign_key: "vendor_id"
  belongs_to :c_agent, class_name: "Vendor", foreign_key: "clearing_agent_id"
  validates :truck_number, presence: true
  validate :assignment_of_truck_number, if: "truck_number.present? && truck_number_changed?"

  delegate :bl_number, to: :bill_of_lading, allow_nil: true
  has_many :invoices, as: :invoiceable
  before_update :assign_w_o_number_to_invoice, if: :w_o_number_changed?

  def assignment_of_truck_number
   count = Movement.where(truck_number: truck_number).where.not(status: :container_handed_over_to_KPA).count
   if count > 0 && truck_number != nil
     errors.add(:truck_number," #{truck_number} is not free !")
   end
  end

  aasm column: 'status' do
    state :loaded, initial: true
    state :under_customs_clearance
    state :enroute_mombasa
    state :arranging_shipping_order_and_vessel_nomination
    state :arrived_port
    state :container_handed_over_to_KPA

    event :arrived_malaba_border do
      transitions from: :loaded, to: :under_customs_clearance
    end

    event :crossed_malaba_border do
      transitions from: :under_customs_clearance, to: :enroute_mombasa
    end

    event :order_released do
      transitions from: :enroute_mombasa, to: :arranging_shipping_order_and_vessel_nomination
    end

    event :arrived_port do
      transitions from: :arranging_shipping_order_and_vessel_nomination, to: :arrived_port
    end

    event :document_handed do
      transitions from: :arrived_port, to: :container_handed_over_to_KPA
    end

  end

  auditable only: [:status, :updated_at, :remarks, :vendor_id, :transporter_payment,
    :clearing_agent, :clearing_agent_payment]

  def ready_haulage_export_invoice
    invoice = Invoice.create(date: Date.current)
    invoice.customer = self.export_item.export.customer
    invoice.invoiceable = self
    invoice.invoice_ready!
  end

  def DT_RowId
    self.id
  end

  def status_and_updated_at_date
    "#{self.status}  \n #{status_updated_at(self).localtime.to_date} "
  end

  def as_json(options= {})
    super(except: [:port_of_loading, :estimate_delivery, :created_at, :updated_at, 
      :vendor_id, :status, :custom_seal], methods: [:DT_RowId, :container_number, 
      :bl_number, :customer_name, :shipping_seal, :transporter_name, 
      :status_and_updated_at_date])
  end

  def container_number
    !export_item.nil? ? self.export_item.container : nil
  end

  def customer_name
    !export_item.nil? ? self.export_item.export.customer.name : nil
  end

  def shipping_seal
    self.export_item.export.shipping_line
  end

  def transporter_name
    self.transporter.try(:name)
  end

  def transporter_name=(transporter_name)
    self.transporter = Vendor.where(name: transporter_name).first
  end

  def equipment_type
    self.export_item.export.equipment
  end

  def is_TBL_type?
    self.movement_type.eql?("TBL")
  end

  def is_Haulage_type?
    self.movement_type.eql?("Haulage")
  end

  def pick_up
    self.port_of_loading
  end

  def destination
    self.port_of_discharge
  end

  def assign_w_o_number_to_invoice
    if (is_Haulage_type? && self.invoices.present?)
      invoices.update_all(document_number: w_o_number)
    else
      if (self.bill_of_lading.present? && bill_of_lading.invoices.present?)
        w_o_numbers = self.bill_of_lading.movements.where.not(id: self.id).pluck(:w_o_number).to_a
        w_o_numbers << self.w_o_number
        invoices = self.bill_of_lading.invoices
        invoices.update_all(document_number: w_o_numbers.join(","))
      end
    end
  end

  def clearing_agent
    self.c_agent.try(:name)
  end

  def clearing_agent=(clearing_agent)
    self.c_agent = Vendor.where(name: clearing_agent).first
  end

end
