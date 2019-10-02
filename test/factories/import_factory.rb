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
  factory :import do |import|
    sequence(:bl_number) { |bl_number| "BL_#{bl_number}"}		   
    to        		   'location 2'
    from      		   'location 1'
    estimate_arrival '10-10-2014'
    equipment        '20GP'
    quantity				  3
    remarks 'remark1'
    rate_agreed 3000
    weight 30
    bl_received_type "copy"
    association				:customer
    work_order_number 1234
  end
end
