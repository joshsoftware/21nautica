FactoryGirl.define do

  factory :invoice, class: "Invoice" do |inv|
    customer
    number 'invoice'
    ledger { FactoryGirl.create(:ledger_with_invoice) } 
  end

  factory :invoice_ledger, class: 'Ledger' do
    customer
    association :voucher, factory: :invoice
    amount 1000
    received 0
    date '2015-08-26' 
  end

end
