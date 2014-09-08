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
#  customer_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#

FactoryGirl.define do
  factory :import do
    bl_number 		   'BL1'
    to        		   'location 2'
    from      		   'location 1'
    shipping_line		 'Evergreen'
    estimate_arrival '10-10-2014'
    equipment        '20GP'
    quantity				  3
    association				:customer 
  end
end
