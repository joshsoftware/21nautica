FactoryGirl.define do
  factory :ledger do
    amount 3000
    date '2015-08-26'
    received 0
    association :customer 
    association :voucher, factory: :invoice
  end
end
