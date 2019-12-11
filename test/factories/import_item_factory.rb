FactoryGirl.define do
  factory :import_item1, class: "ImportItem" do
  	sequence(:container_number) { |n| "CONT1#{n}" }
  end

  factory :import_item2, class: "ImportItem" do
    sequence(:container_number) { |n| "CONT2#{n}" }
  end

  factory :import_item3, class: "ImportItem" do
  	sequence(:container_number) { |n| "CONT3#{n}" }
  end

  factory :import_item, class: "ImportItem" do
  	sequence(:container_number) { |con| "container_number_#{con}" }
    association :import
    status 'truck_allocated'
    association :truck
  end

end
