class Payment < ActiveRecord::Base
  validates_presence_of :amount
  self.inheritance_column = :type
  def self.types
    %w(Paid Received)
  end
  scope :paid, -> { where(type: 'Paid') }
  scope :received, -> { where(type: 'Received') }
end
