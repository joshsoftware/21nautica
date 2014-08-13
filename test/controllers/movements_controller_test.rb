  require 'test_helper'
  require 'mocha/test_unit'
  require "minitest/autorun"

class MovementsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @movement = FactoryGirl.create :movement
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
  end

  status=["loaded",
            "under_customs_clearance",
            "enroute_mombasa",
            "arranging_shipping_order_and_vessel_nomination",
            "arrived_port"]

  status.each do |state|
    define_method("test_#{state}_alert") do
      @movement.status = state
      @movement.save
      time_now = Time.now + STATUS_CHANGE_DURATION[@movement.aasm.events.first.to_sym].day
      Time.stubs(:now).returns(time_now.getlocal)
      get :index  
      assert_select 'table>tbody' do |element|
        assert_select "tr[class=?]", "danger" 
      end
    end
  end

end
