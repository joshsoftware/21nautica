# == Schema Information
#
# Table name: export_items
#
#  id                :integer          not null, primary key
#  container         :string(255)
#  location          :string(255)
#  weight            :string(255)
#  export_id         :integer
#  movement_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  date_of_placement :date
#

FactoryGirl.define do
  
  factory :export_item do
    container '1'
    location  'test location1'
    date_of_placement Date.today  
    :export
  end

  factory :export_item1, class:ExportItem do
    container '2'
    location  'test location2'
    date_of_placement Date.yesterday  
    :export
  end
  
end