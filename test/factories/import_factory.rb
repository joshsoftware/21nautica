# == Schema Information
#
# Table name: imports
#
#  id               :integer          not null, primary key
#  equipment        :string(255)
#  quantity         :integer
#  from             :string(255)
#  to               :string(255)
#  bl_number        :string(255)
#  estimate_arrival :date
#  description      :string(255)
#  rate             :string(255)
#  status           :string(255)
#  out_of_port_date :date
#  created_at       :datetime
#  updated_at       :datetime

FactoryGirl.define do
  
  factory :import do
    equipment '20'
    quantity  '20'
    from      'location 1'
    to        'location 2'
    bl_number '12345678'
  end
end
