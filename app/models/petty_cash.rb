class PettyCash < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User'
  belongs_to :expense_head
  belongs_to :truck
  validates :date, :transaction_type, :transaction_amount, presence: true

end
