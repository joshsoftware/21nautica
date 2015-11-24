FactoryGirl.define do
  factory :bill_of_lading do
  	sequence(:bl_number) { |number| "BL2#{number}_abc#{number}" }
    association :import
  end

  factory :bill_of_lading1, class: "BillOfLading"  do
  	sequence(:bl_number) { |number| "BL3#{number}" }
  end
end

