FactoryGirl.define do

	factory :customer do
		name { Faker::Name.name }
		emails 'cust1@gmail.com'
	end
end