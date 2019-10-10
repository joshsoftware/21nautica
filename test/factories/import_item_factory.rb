FactoryGirl.define do
  factory :import_item1, class: "ImportItem" do
  	container_number	'c1'
    #transporter_name 'Mansons'
  end

  factory :import_item2, class: "ImportItem" do
  	container_number	'c2'
  end

  factory :import_item3, class: "ImportItem" do
  	container_number	'c3'
  end

  factory :import_item, class: "ImportItem" do
  	sequence(:container_number) { |con| "container_number_#{con}" }
    association :import
  end

end
