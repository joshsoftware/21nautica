FactoryGirl.define do

  factory :user do
    #email 'k@gmail.com'
	  sequence(:email) {|n| "abcd#{n}@gmail.com" }	
    password 'k12345678'
    is_active true
  end
end
