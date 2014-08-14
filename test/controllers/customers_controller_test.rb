require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
  	@user = FactoryGirl.create :user
    sign_in @user
	end

  test "should get new" do
    xhr :get, :new
    assert_not_nil assigns(:customer)
    assert_response :success
  end

	test "should create customer" do
    assert_difference('Customer.count') do
    	xhr  :post, :create, customer: {name: 'Some Name', emails: 'some@example.com'}
    	assert_response :success
  	end
  end

  test "should create daily report for customer" do

  end	

end
