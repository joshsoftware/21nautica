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
  setup do
    @movement1 = FactoryGirl.create :movement
  end

  test "should not assign truck which is not free" do
    movement2 = Movement.new
    movement2.truck_number = "t1"
    assert_not movement2.save
    assert movement2.errors.messages[:truck_number].include?(
                      " t1 is not free !")
  end

  test "should not save movement without truck number" do
    movement = Movement.new
    assert_not movement.save
    assert movement.errors.messages[:truck_number].include?(
                    "can't be blank")
  end

  test "json should include container field" do
    assert_not @movement1.attributes.has_key?('container_number')
    assert @movement1.as_json.has_key?('container_number')
  end

end
