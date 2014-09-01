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
  belongs_to :import 

  aasm column: 'status' do
    state :under_loading_process, initial: true
    state :truck_allocated
    state :enroute_nairobi
    state :enroute_malaba
    state :awaiting_clearance
    state :enroute_kampala
    state :arrived_kampala
    state :delivered

    event :allocate_truck do
      transitions from: :under_loading_process, to: :truck_allocated
    end

    event :loaded_out_of_port do
      transitions from: :truck_allocated, to: :enroute_nairobi
    end

    event :crossed_nairobi do
      transitions from: :enroute_nairobi, to: :enroute_malaba
    end

    event :arrived_malaba do
      transitions from: :enroute_malaba, to: :awaiting_clearance
    end

    event :clearance_complete do
      transitions from: :awaiting_clearance, to: :enroute_kampala
    end

    event :arrived_at_kampala do
      transitions from: :enroute_kampala, to: :arrived_kampala
    end

    event :item_delivered do
      transitions from: :arrived_kampala, to: :delivered
    end

  end

  auditable only: [:status, :updated_at, :current_location]

end
