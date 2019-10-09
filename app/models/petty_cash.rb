# Petty Cash Model
class PettyCash < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :expense_head
  belongs_to :truck
  validates_length_of :description, within: 0..100, on: :create, message: "Description should be within 100 char" 
  validates  :transaction_type, :transaction_amount, presence: true
  before_create :update_balance
  
  def update_balance
    self.available_balance = if transaction_type.eql?('Deposit')
                               current_balance + transaction_amount
                             else
                               current_balance - transaction_amount
                             end
  end

  def self.update_transport_cash(current_user, transaction_amount)
    last_balance = TransportMangerCash.where.not(transaction_date: nil).last.try(:available_balance).to_f
    current_balance = last_balance + transaction_amount.to_f
    transport_manger_cash = current_user.transport_manger_cashes.new(transaction_date: Date.today, transaction_type: 'Deposite',transaction_amount: transaction_amount, available_balance: current_balance)
    transport_manger_cash.save
  end
  
  private

  def current_balance
    PettyCash.last.try(:available_balance).to_f
  end
end
