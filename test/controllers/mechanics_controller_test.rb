require 'test_helper'

class MechanicsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @mechanic = FactoryGirl.create :mechanic
  end

  test 'should get index' do
    get :index
    assert_not_nil assigns(:mechanics)
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:mechanic)
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @mechanic.id
    assert_not_nil assigns(:mechanic)
    assert_response :success
  end

  test 'should create mechanic' do
    assert_difference 'Mechanic.count', 1 do
      post :create, mechanic: { name: 'Bangar'}
      assert_redirected_to action: 'index'
    end
  end

  test 'should edit mechanic' do
    assert_no_difference 'Mechanic.count' do
      put :update, mechanic: { name: 'Bangar Prashant' }, id: @mechanic.id
      @mechanic.reload
      assert_equal 'Bangar Prashant', @mechanic.name
      assert_redirected_to action: 'index'
    end
  end
end
