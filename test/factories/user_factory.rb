FactoryGirl.define do

  factory :user do
    #email 'k@gmail.com'
	  sequence(:email) {|n| "abcd#{n}@gmail.com" }	
    password 'k12345678'
  end
end
