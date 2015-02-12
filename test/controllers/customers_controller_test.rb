require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup do
  	@user = FactoryGirl.create :user
    sign_in @user
    @movement = FactoryGirl.create :movement
    @export = FactoryGirl.create :export
    @export_item = FactoryGirl.create :export_item
    @export_item.export = @export
    @export_item.movement =@movement
	end

  test "should get new" do
    xhr :get, :new
    assert_not_nil assigns(:customer)
    assert_response :success
    assert_template layout: nil
  end

	test "should create customer" do
    assert_difference('Customer.count') do
    	xhr  :post, :create, customer: {name: 'Some Name', emails: 'some@example.com'}
    	assert_response :success
  	end
  end

  test "should create daily import report for customer" do

  end

  test "should create daily export report for customer" do

  end

end
