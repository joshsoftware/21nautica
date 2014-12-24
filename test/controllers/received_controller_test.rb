require 'test_helper'

class ReceivedControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
  end

  test "should get new" do
    get :new
    assert_not_nil assigns(@received)
    assert_response :success
  end

  test "should create received payment" do
    assert_difference('Received.count') do
      post :create, received: {amount: 400}
    end
    assert_response :redirect
  end

  test "should not save received payment without amount" do
    assert_no_difference('Received.count') do
      post :create, received: {customer_id: 1}
    end
    assert_response :success
  end

end
