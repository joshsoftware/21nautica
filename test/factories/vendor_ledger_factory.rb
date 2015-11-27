FactoryGirl.define do
  factory :vendor_ledger do
    amount 3000
    date '2015-08-26'
    paid 0
    currency 'USD'
    association :vendor 
    association :voucher, factory: :bill
  end

  factory :vendor_ledger_with_debit_note, class: 'VendorLedger' do
    amount 100
    date '2015-08-26'
    paid 0
    currency 'USD'
    association :vendor 
    association :voucher, factory: :debit_note
  end
end
