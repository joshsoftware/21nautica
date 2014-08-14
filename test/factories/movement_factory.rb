# == Schema Information
#
# Table name: movements
#
#  id                   :integer          not null, primary key
#  booking_number       :string(255)
#  truck_number         :string(255)
#  vessel_targeted      :string(255)
#  port_of_discharge 		:string(255)
#  port_of_loading    	:string(255)
#  estimate_delivery    :date
#  movement_type        :string(255)
#  shipping_seal        :string(255)
#  custom_seal          :string(255)
#  remarks              :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  transporter_name     :string(255)
#  w_o_number           :string(255)

FactoryGirl.define do 
	factory :movement do
  	booking_number '1'
  	truck_number 't1'
  	status 'loaded'
  end
end
