FactoryGirl.define do
  factory :fuel_entry do
    quantity 10
    cost 30
    date Date.today
    is_adjustment false
    truck_id 9
  end
end
