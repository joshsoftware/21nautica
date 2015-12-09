FactoryGirl.define do

  factory :invoice, class: "Invoice" do |inv|
    customer
    number 'invoice'
    ledger { FactoryGirl.create(:ledger_with_invoice) } 
    association :invoiceable, factory: :bill_of_lading
  end

  factory :invoice_ledger, class: 'Ledger' do
    customer
    association :voucher, factory: :invoice
    amount 1000
    received 0
    date '2015-08-26' 
  end

end
