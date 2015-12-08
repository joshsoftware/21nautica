FactoryGirl.define do

	factory :customer do
		name { Faker::Name.name }
		sequence(:emails) { |emails| "cust_#{emails}@gmail.com" }

    transient do
      customer_ledger_count 1
    end

    factory :customer_with_ledgers do
      after(:create) do |customer, evaluator|
        #create_list(:ledger_with_received, evaluator.customer_ledger_count, customer: customer)
        create_list(:customer_ledgers, evaluator.customer_ledger_count, customer: customer)
      end
    end

	end

  factory :customer_ledgers, class: 'Ledger' do
    amount 3000
    date '2015-08-26'
    received 0
    association :customer 
    association :voucher, factory: :received
  end
end
