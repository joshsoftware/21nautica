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
