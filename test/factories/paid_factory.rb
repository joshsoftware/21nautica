FactoryGirl.define do
	factory :paid, class: 'Paid' do
    date_of_payment '2015-08-26' 
    amount 500
    currency 'USD'
    mode_of_payment 'Cheque'
    reference 'some ref'
    remarks 'test'
    association :vendor
  end
end
