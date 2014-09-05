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
	include EspinitaPatch

  has_many :import_items
  belongs_to :customer
  validates_uniqueness_of :bl_number
  accepts_nested_attributes_for :import_items

  aasm column: 'status' do
    state :copy_documents_received, initial: true
    state :original_documents_received
    state :container_discharged
    state :ready_to_load

    event :original_documents_received do
      transitions from: :copy_documents_received, to: :original_documents_received
    end

    event :container_discharged do
      transitions from: :original_documents_received, to: :container_discharged
    end

    event :ready_to_load do
      transitions from: :container_discharged, to: :ready_to_load
    end

  end

  auditable only: [:status, :updated_at, :remarks]

end
