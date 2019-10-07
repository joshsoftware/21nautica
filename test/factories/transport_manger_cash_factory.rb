FactoryGirl.define do
  factory :transport_manger_cash do
    transaction_amount 290.34
    transaction_type 'Withdrawal'
    available_balance 0.0
    association :created_by, factory: :user
    association :truck
    association :import_item
    association :import
  end
end
