class ImportItem < ActiveRecord::Base
  include AASM

  aasm column: 'status' do
    state :waiting_truck_allocation, initial: true
    state :awaiting_loading
    state :loaded_out

    event :allocate_truck do
      transitions from: :waiting_truck_allocation, to: :awaiting_loading
    end

    event :load_truck do
      transitions from: :awaiting_loading, to: :loaded_out
    end
  end
end
