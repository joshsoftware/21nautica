require 'test_helper'
class BreakdownReasonsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @breakdown_reason = FactoryGirl.create :breakdown_reason
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:breakdown_reason)
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_not_nil assigns(:breakdown_reasons)
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @breakdown_reason.id
    assert_not_nil assigns(:breakdown_reason)
    assert_response :success
  end

  test 'should create breakdown reason ' do
    assert_difference "BreakdownReason.count", 1 do
      post :create, breakdown_reason: { name: 'Break fail' }
      assert_redirected_to action: 'index'
      end
    end

  test 'should edit breakdown reason' do
    assert_no_difference "BreakdownReason.count" do
      put :update, breakdown_reason: { name: 'break' }, id: @breakdown_reason.id
      @breakdown_reason.relaod!
      assert_equal 'break', @breakdown_reason.name
      assert_redirected_to action: 'index'
    end
  end

end
