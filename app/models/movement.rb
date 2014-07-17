# == Schema Information
#
# Table name: movements
#
#  id                   :integer          not null, primary key
#  booking_number       :string(255)
#  truck_number         :string(255)
#  vessel_targeted      :string(255)
#  point_of_destination :string(255)
#  point_of_loading     :string(255)
#  estimate_delivery    :date
#  movement_type        :string(255)
#  shipping_seal        :string(255)
#  custom_seal          :string(255)
#  current_location     :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class Movement < ActiveRecord::Base
  include AASM

  aasm column: 'status' do
    state :loaded, initial: true
    state :arrived_malaba_border
    state :crossed_malaba_border
    state :order_released
    state :arrived_port
    state :document_handed

    event :enter_malaba_border do
      transitions from: :loaded, to: :arrived_malaba_border
    end

    event :exit_malaba_border do
      transitions from: :arrived_malaba_border, to: :crossed_malaba_border
    end

    event :release_order do
      transitions from: :crossed_malaba_border, to: :order_released
    end

    event :enter_port do
      transitions from: :order_released, to: :arrived_port
    end

    event :handover_document do
      transitions from: :arrived_port, to: :document_handed
    end

  end
  
  auditable only: [:status, :updated_at, :current_location]

end
