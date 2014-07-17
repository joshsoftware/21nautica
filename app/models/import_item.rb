# == Schema Information
#
# Table name: import_items
#
#  id               :integer          not null, primary key
#  container_number :string(255)
#  trailer_number   :string(255)
#  tr_code          :string(255)
#  truck_number     :string(255)
#  current_location :string(255)
#  bond_direction   :string(255)
#  bond_number      :string(255)
#  status           :string(255)
#  import_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ImportItem < ActiveRecord::Base
  include AASM

  aasm column: 'status' do
    state :waiting_truck_allocation, initial: true
    state :awaiting_loading
    state :loaded_out
    state :delivered

    event :allocate_truck do
      transitions from: :waiting_truck_allocation, to: :awaiting_loading
    end

    event :load_truck do
      transitions from: :awaiting_loading, to: :loaded_out
    end

    event :item_delivered do
      transitions from: :loaded_out, to: :delivered
    end

  end
  
  auditable only: [:status, :updated_at, :current_location]

end
