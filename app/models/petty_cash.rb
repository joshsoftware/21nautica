# Petty Cash Model
class PettyCash < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :expense_head
  belongs_to :truck
  validates_length_of :description, within: 0..100, on: :create, message: "Description should be within 100 char" 
  validates  :transaction_type, :transaction_amount, presence: true
  before_create :update_balance
  scope :having_records_between, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :of_account_type, -> (value) { where(:account_type => value)}
  def update_balance
    self.available_balance = if transaction_type.eql?('Deposit')
                               current_balance + transaction_amount
                             else
                               current_balance - transaction_amount
                             end
  end
  
  private

  def current_balance
    if self.account_type.eql?('Cash')
      PettyCash.of_account_type(self.account_type).last.try(:available_balance).to_f
    else
      PettyCash.of_account_type(self.account_type).last.try(:available_balance).to_f
    end
  end
end
