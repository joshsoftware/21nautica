require 'test_helper'

class BreakdownManagementsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @breakdown_management = FactoryGirl.create :breakdown_management
    @truck = FactoryGirl.create :truck
    @breakdown_reason = FactoryGirl.create :breakdown_reason
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:breakdown_management)
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_not_nil assigns(:breakdown_managements)
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @breakdown_management.id
    assert_not_nil assigns(:breakdown_management)
    assert_response :success
  end

  test 'should create breakdown reason ' do
    assert_difference "BreakdownManagement.count" do
      post :create, breakdown_management: { date: Date.current,
                                            location: 'Mumbai',
                                            parts_required: true,
                                            sending_date:Date.current,
                                            status: 'Open',
                                            truck_id: @truck.id,
                                            breakdown_reason_id: @breakdown_reason.id}
      assert_redirected_to action: "index"
      end
    end

  test 'should edit breakdown reason' do
    assert_no_difference "BreakdownManagement.count" do
      put :update, breakdown_management: { status: 'Close' }, id: @breakdown_management.id
      @breakdown_management.reload
      assert_equal 'Close', @breakdown_management.status
      assert_redirected_to action: 'index'
    end
  end
end
