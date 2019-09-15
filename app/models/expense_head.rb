# Expense Head Module
class ExpenseHead < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 30 }
  scope :active, -> { where(:is_active => true)}
  has_many :petty_cashes
end
