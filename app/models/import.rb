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

  accepts_nested_attributes_for :import_items
  
  aasm column: 'status' do
    state :new, initial: true
    state :copy_document_received
    state :awaiting_vessel_arrival
    state :awaiting_container_arrival
    state :container_discharged
    state :completed

    event :recieve_copy_document do
      transitions from: :new, to: :copy_document_received
    end

    event :recieve_original_document do
      transitions from: [:new, :copy_document_received], to: :awaiting_vessel_arrival
    end
    
    event :lodge_entry do
      transitions from: :awaiting_vessel_arrival, to: :awaiting_container_arrival
    end

    event :discharge_container do
      transitions from: :awaiting_container_arrival, to: :container_discharged
    end

    event :order_delivered do
      transitions from: :container_discharged, to: :completed
    end
  end
  
  auditable only: [:status, :updated_at]

end
