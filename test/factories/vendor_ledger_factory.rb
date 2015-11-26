FactoryGirl.define do
  factory :vendor_ledger do
    amount 3000
    date '2015-08-26'
    paid 0
    currency 'USD'
    association :vendor 
    association :voucher, factory: :bill
  end
end
