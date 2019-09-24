FactoryGirl.define do
  factory :petty_cash do
    description 'Paid to'
    transaction_amount 290.34
    transaction_type 'Withdrawal'
    date '18/10/2019'
    available_balance 0.0
    association :created_by, factory: :user
    association :expense_head, factory: :expense_head
    association :truck
  end
end
