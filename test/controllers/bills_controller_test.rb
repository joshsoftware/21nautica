require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
