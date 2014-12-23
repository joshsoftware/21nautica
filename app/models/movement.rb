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

  has_one :export_item
  belongs_to :bill_of_lading
  belongs_to :vendor
  validates :truck_number, presence: true
  validate :assignment_of_truck_number, if: "truck_number.present? && truck_number_changed?"

  delegate :bl_number, to: :bill_of_lading, allow_nil: true

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

  auditable only: [:status, :updated_at, :remarks, :transporter_name, :transporter_payment,
    :clearing_agent, :clearing_agent_payment]

  def as_json(options= {})
    super(methods: [:container_number])
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
    self.vendor.try(:name)
  end

  def transporter_name=(transporter_name)
    vendor_id = Vendor.where(name: transporter_name).first.try(:id)
    self.vendor_id = vendor_id
  end

end
