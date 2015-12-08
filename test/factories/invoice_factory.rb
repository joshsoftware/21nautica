FactoryGirl.define do

  factory :invoice, class: "Invoice" do |inv|
    customer
    number 'invoice'
    ledger { FactoryGirl.create(:ledger_with_invoice) } 
  end

  factory :invoice_ledger, class: 'Ledger' do
    association :voucher, factory: :invoice
  end

end
