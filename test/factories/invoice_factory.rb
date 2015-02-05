FactoryGirl.define do

  factory :invoice, class: "Invoice" do
    customer
    number 'invoice'
  end

end
