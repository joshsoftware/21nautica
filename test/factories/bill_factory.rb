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


    transient do
      debit_notes_count 1
    end

    factory :bill_with_debit_note do
      after(:create) do |bill, evaluator|
        create_list(:debit_note, evaluator.debit_notes_count, bill: bill)
      end
    end

	end
end
