class Vendor < ActiveRecord::Base
  has_many :payments
  has_many :bills
  has_many :bill_items
  validates :vendor_type, inclusion: { in: %w(transporter clearing_agent) }
  scope :transporters, -> { where(vendor_type: 'transporter') }
  scope :clearing_agents, -> { where(vendor_type: 'clearing_agent') }
end
