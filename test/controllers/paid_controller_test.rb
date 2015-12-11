require 'test_helper'

class PaidControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    @vendor = FactoryGirl.create(:vendor_with_vendor_ledgers)
    @paid = FactoryGirl.create(:paid) 
    sign_in @user
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not save paid payment without amount" do
    assert_no_difference('Paid.count') do
      post :create, paid: {vendor_id: @vendor.id}
    end
    assert_response :success
  end

  test "should create paid payment" do
    assert_difference('Paid.count') do
      post :create, paid: {vendor_id: @vendor.id, amount: 500, currency: 'USD', date_of_payment: "2014-10-02", type: 'Cheque'}
    end
    assert_response :redirect
  end

  test 'it should get index' do
    xhr :get, :index, {vendor_id: @vendor.id}
    assert_not_nil assigns(@payment)
    assert_response :success
  end

  test 'should delete the payments paid' do
    vendor_id = @paid.vendor_id
    assert_difference('Paid.count', -1) do
      delete :delete_ledger, id: @paid.id 
    end
    assert_redirected_to readjust_path(vendor_id) 
  end

  test 'should get the show' do
    get :show, id: @vendor.id 
  end
  
  test 'should get the outstanding' do
    assert_response :success
  end

  test 'it should readjust the payments' do
    get :readjust, id: @vendor.id
    assert_redirected_to new_paid_path
  end

end
