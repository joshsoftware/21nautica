# Petty Cash Model
class PettyCash < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :expense_head
  belongs_to :truck
  validates  :transaction_type, :transaction_amount, presence: true
  before_create :update_date, :update_balance
  after_create :check_expense_head
  def update_date
    self.date = Date.today.strftime('%d/%m/%Y')
  end

  def update_balance
    self.available_balance = if transaction_type.eql?('Deposit')
                               current_balance + transaction_amount
                             else
                               current_balance - transaction_amount
                             end
  end
  def check_expense_head
    if expense_head.name.eql?('Trip Allowence')
      last_balance = TransportMangerCash.where.not(transaction_date:nil).last.try(:available_balance).to_f
      balance = last_balance + self.transaction_amount
      transport = TransportMangerCash.new(transaction_date:Date.today, transaction_type: 'Deposit', transaction_amount: self.transaction_amount, available_balance: balance )
      transport.save
    end
  end
  private

  def current_balance
    PettyCash.last.try(:available_balance).to_f
  end
end
