require 'test_helper'

class ReceivedControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    @customer = FactoryGirl.create :customer_with_ledgers
    @received = FactoryGirl.create :received
    sign_in @user
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create received payment" do
    assert_difference('Received.count') do
      post :create, received: {customer_id: @customer.id, amount: 400, date_of_payment: "2014-10-02"}
    end
    assert_response :redirect
  end

  test "should not save received payment without amount" do
    assert_no_difference('Received.count') do
      post :create, received: {customer_id: 1}
    end
    assert_response :success
  end

  test 'it should get index' do
    xhr :get, :index, {customer_id: @customer.id}
    assert_not_nil assigns(@payment)
    assert_response :success
  end

  test 'should get the show' do
    get :show, id: @customer.id 
  end
  
  test 'should get the outstanding' do
    assert_response :success
  end

  test 'it should readjust the payments' do
    get :readjust, id: @customer.id
    assert_redirected_to new_received_path
  end

  test 'should delete the payments paid' do
    customer_id = @received.customer_id
    assert_difference('Received.count', -1) do
      delete :delete_ledger, id: @received.id 
    end
    assert_redirected_to readjust_customer_path(customer_id) 
  end

end
