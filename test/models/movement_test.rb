# == Schema Information
#
# Table name: movements
#
#  id                   :integer          not null, primary key
#  booking_number       :string(255)
#  truck_number         :string(255)
#  vessel_targeted      :string(255)
#  point_of_destination :string(255)
#  point_of_loading     :string(255)
#  estimate_delivery    :date
#  movement_type        :string(255)
#  shipping_seal        :string(255)
#  custom_seal          :string(255)
#  current_location     :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class MovementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
