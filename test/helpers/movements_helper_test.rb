require 'test_helper'

class MovementsHelperTest < ActionView::TestCase
  include MovementsHelper
  setup do
    @movement = FactoryGirl.create :movement
  end
  
  test "alert" do
    updated_at = Time.now
    assert_equal false, alert(updated_at, @movement)                
    updated_at = Time.now - 3.days
    assert_equal true, alert(updated_at, @movement)
  end

  test "status_updated_at" do
    @movement.status = "under_customs_clearance"
    @movement.save
    t1 = Time.now 
    sleep(5.seconds)
    @movement.remarks = "R1"
    @movement.save
    assert_equal t1.to_i, status_updated_at(@movement).to_i   
  end
end
