FactoryGirl.define do
	factory :bill_item  do |f|
    item_type 'Import'
    item_for 'container'
    item_number 'c1'
    charge_for 'Agency Fee'
    quantity 1
    rate 1000
    line_amount 1000
    association :bill
    association :activity, factory: :import
    
    #import = FactoryGirl.create(:import)
=begin
  transient do 
    import 1
  end

   factory :bill_items_with_import do
     after(:build) do |bill_item, evaluator|
       create_list(:import, evaluator.import, bill_item: bill_item)
     end
   end
=end
	end
end
