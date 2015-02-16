class Vendor < ActiveRecord::Base
  has_many :payments
  validates :vendor_type, inclusion: { in: %w(transporter clearing_agent) }
end
