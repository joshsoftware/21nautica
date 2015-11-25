FactoryGirl.define do
	factory :bill, class: 'Bill' do
	  sequence(:bill_number) {|n| "bill-#{n}" }	
    bill_date '2015-08-26' 
    value 1000
    remark 'test'
    currency 'USD'

    association :created_by, factory: :user
    association :approved_by, factory: :user
    association :vendor

    after :build do |bill, evaluator| 
      bill.bill_items << FactoryGirl.build_list(:bill_item, 1, bill: bill)
    end
    #FactoryGirl.create(:bill_ite)
=begin
  transient do 
    bill_item 1
  end

   factory :bill_with_bill_items do
     after(:build) do |bill, evaluator|
       create_list(:bill_item, evaluator.bill_item, bill: bill)
     end
   end
=end

	end
end
