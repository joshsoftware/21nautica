FactoryGirl.define do
  factory :import_item1, class: "ImportItem" do
  	container_number	'c1'
  end

  factory :import_item2, class: "ImportItem" do
    container_number	'c2'
  end

  factory :import_item3, class: "ImportItem" do
  	container_number	'c3'
  end

  factory :import_item, class: "ImportItem" do
  	sequence(:container_number) { |con| "container_number_#{con}_#{Time.now.to_i}" }
    association :import
    status 'truck_allocated'
    association :truck
  end

end
