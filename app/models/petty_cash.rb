# Petty Cash Model
class PettyCash < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :expense_head
  belongs_to :truck
  validates  :transaction_type, :transaction_amount, presence: true
  before_create :update_date

  def update_date
    self.date = Date.current.strftime('%d/%m/%y')
  end
end
