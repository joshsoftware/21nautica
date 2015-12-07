class Vendor < ActiveRecord::Base
  has_many :payments
  has_many :bills
  has_many :bill_items
  has_many :debit_notes
  has_many :vendor_ledgers

  validates_presence_of :name, :vendor_type

  validate :check_vendor_type
  scope :transporters, -> { where('vendor_type like ?', "%transporter%").order(:name) }
  scope :clearing_agents, -> { where('vendor_type like ?', "%clearing_agent%").order(:name) }
  scope :shipping_lines, -> { where('vendor_type like ?', "%shipping_line%").order(:name) }


  private
  def check_vendor_type
    vendor_type.split(',').each do|v|
      errors.add(:vendor_type, 'Invalid vendor type') unless ['transporter', 'clearing_agent', 'shipping_line', 
                                                              'icd', 'final_clearing_agent'].include? v
    end unless vendor_type.blank?
  end
end
