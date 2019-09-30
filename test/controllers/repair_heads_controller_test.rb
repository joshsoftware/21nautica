require 'test_helper'

class RepairHeadsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @repair_head = FactoryGirl.create :repair_head
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:repair_head)
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @repair_head.id
    assert_not_nil assigns(:repair_head)
    assert_response :success
  end

  test 'should create repair head' do
    assert_difference 'RepairHead.count' do
      post :create, repair_head: { name: 'NM!123' }
      assert_redirected_to action: 'index'
    end
  end

  test 'should update repair_head' do
    assert_no_difference 'RepairHead.count' do
      put :update, repair_head: { name: 'NM!12', is_active: false }, id: @repair_head.id
      @repair_head.reload
      assert_equal 'NM!12', @repair_head.name
      assert_equal false, @repair_head.is_active
    end
  end
end
