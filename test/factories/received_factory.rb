FactoryGirl.define do
	factory :received, class: 'Received' do |rec|
    rec.date_of_payment '2015-08-26' 
    rec.amount 500
    rec.currency 'USD'
    rec.mode_of_payment 'Cheque'
    rec.reference 'some ref'
    rec.remarks 'test'
    rec.association :customer
    #rec.after_create  { |r| FactoryGirl.create(:ledger, :voucher => r) } 
  end

  factory :received_ledger, class: 'Ledger' do
    customer
    association :voucher, factory: :received
    date '2015-08-27' 
    amount 500
    received 0
  end

end
