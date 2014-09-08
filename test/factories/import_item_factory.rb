FactoryGirl.define do
  
  factory :import_item1, class: ImportItem do
  	container_number	'c1'   
  	association				:import
  end

  factory :import_item2, class: ImportItem do
  	container_number	'c2'  
  	association				:import 
  end

  factory :import_item3, class: ImportItem do
  	container_number	'c3'   
  	association				:import
  end

end