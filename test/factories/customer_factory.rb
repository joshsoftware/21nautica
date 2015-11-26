FactoryGirl.define do

	factory :customer do
		name { Faker::Name.name }
		sequence(:emails) { |emails| "cust_#{emails}@gmail.com" }

    transient do
      customer_ledger_count 1
    end

    factory :customer_with_ledgers do
      after(:create) do |customer, evaluator|
        create_list(:ledger, evaluator.customer_ledger_count, customer: customer)
      end
    end

	end
end
