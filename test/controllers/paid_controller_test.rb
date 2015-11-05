require 'test_helper'

class PaidControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
  end

  test "should get new" do
    get :new
    assert_not_nil assigns(@paid)
    assert_response :success
  end

  test "should create paid payment" do
    assert_difference('Paid.count') do
      post :create, paid: {vendor_id: 1, amount: 400, currency: 'USD', date_of_payment: "2014-10-02"}
    end
    assert_response :redirect
  end

  test "should not save paid payment without amount" do
    assert_no_difference('Paid.count') do
      post :create, paid: {vendor_id: 1}
    end
    assert_response :success
  end

end
