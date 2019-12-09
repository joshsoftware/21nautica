# Petty Cash Model
class PettyCash < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :expense_head
  belongs_to :truck
  validates_length_of :description, within: 0..100, on: :create, message: "Description should be within 100 char" 
  validates  :transaction_type, :transaction_amount, presence: true
  # before_create :update_balance
  scope :having_records_between, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :of_account_type, -> (value) { where(:account_type => value)}

  private

  def self.adjust_balance(key)
    @petty_cashes = PettyCash.of_account_type(key).where(available_balance:nil).order(:id)
    # current_balance = PettyCash.of_account_type(key).where.not(available_balance:nil).order(:id).last.try(:available_balance).to_f
    @petty_cashes.each do|petty_cash|
      current_balance = PettyCash.of_account_type(key).where.not(available_balance:nil).order(:id).last.try(:available_balance).to_f
      available_balance = if petty_cash.transaction_type.eql?('Deposit')
                            current_balance + petty_cash.transaction_amount.to_f
                          else
                            current_balance - petty_cash.transaction_amount.to_f
                          end
      petty_cash.update_attribute(:available_balance,available_balance)
    end
  end

end