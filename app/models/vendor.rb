class Vendor < ActiveRecord::Base
  has_many :payments
  has_many :bills
  has_many :bill_items
  has_many :debit_notes
  validate :check_vendor_type
  scope :transporters, -> { where('vendor_type like ?', "%transporter%") }
  scope :clearing_agents, -> { where(vendor_type: 'clearing_agent') }

  private
  def check_vendor_type
    vendor_type.split(',').each do|v|
      errors.add(:vendor_type, 'Invalid vendor type') unless ['transporter', 'clearing_agent', 'shipping_line', 'icd'].include? v
    end
  end
end
