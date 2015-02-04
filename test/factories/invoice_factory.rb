FactoryGirl.define do

  factory :invoice, class: "Invoice" do
    customer_id (FactoryGirl.create :customer).id
  	number	'invoice'
  end

end
