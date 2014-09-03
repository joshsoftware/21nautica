# == Schema Information
#
# Table name: imports
#
#  id               :integer          not null, primary key
#  equipment        :string(255)
#  quantity         :integer
#  from             :string(255)
#  to               :string(255)
#  bl_number        :string(255)
#  estimate_arrival :date
#  description      :string(255)
#  rate             :string(255)
#  status           :string(255)
#  out_of_port_date :date
#  customer_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Import < ActiveRecord::Base
  include AASM

  has_many :import_items
  belongs_to :customer
  validates_uniqueness_of :bl_number
  accepts_nested_attributes_for :import_items

  aasm column: 'status' do
    state :awaiting_original_documents, initial: true
    state :awaiting_vessel_arrival_and_manifest
    state :awaiting_container_discharge
    state :awaiting_customs_release
    state :awaiting_release_order
    state :awaiting_truck_allocation


    event :original_documents_received do
      transitions from: :awaiting_original_documents, to: :awaiting_vessel_arrival_and_manifest
    end

    event :vessel_arrived do
      transitions from: :awaiting_vessel_arrival_and_manifest, to: :awaiting_container_discharge
    end

    event :container_discharged do
      transitions from: :awaiting_container_discharge, to: :awaiting_customs_release
    end

    event :customs_entry_passed  do
      transitions from: :awaiting_customs_release, to: :awaiting_release_order
    end

    event :release_order_secured do
      transitions from: :awaiting_release_order, to: :awaiting_truck_allocation
    end

  end

  auditable only: [:status, :updated_at]

end
