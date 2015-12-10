FactoryGirl.define do
  factory :particular, class: "Particular" do |inv|
    name 'Haulage'
    rate 1000
    quantity 1
    subtotal 1000
    association :invoice
  end
end
