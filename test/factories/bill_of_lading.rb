FactoryGirl.define do
  factory :bill_of_lading do
  	bl_number 'BL2'
  end

  factory :bill_of_lading1, class: "BillOfLading"  do
  	bl_number 'BL3'
  end
end

