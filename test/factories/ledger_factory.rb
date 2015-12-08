FactoryGirl.define do
  factory :ledger_with_received, class: 'Ledger' do
    amount 3000
    date '2015-08-26'
    received 0
    association :customer 
    #association :voucher, factory: :received
  end
  factory :ledger_with_invoice, class: 'Ledger' do
    amount 3000
    date '2015-08-26'
    received 0
    association :customer 
    #association :voucher, factory: :invoice
  end
end
