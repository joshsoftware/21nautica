FactoryGirl.define do
	factory :received, class: 'Received' do
    date_of_payment '2015-08-26' 
    amount 500
    currency 'USD'
    mode_of_payment 'Cheque'
    reference 'some ref'
    remarks 'test'
    association :customer
  end
end
