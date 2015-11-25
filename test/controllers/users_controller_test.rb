require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user, role: 'Admin')
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test 'should create new user record' do
    assert_difference('User.count') do
      post :create, user: FactoryGirl.attributes_for(:user, name: 'paritosh', email: 'paritosh@gmail.com', 
                                                     password: 'paritosh123', password_confirmation: 'paritosh123', role: 'Admin')
    end
    assert_redirected_to users_path
  end

  test "should not save user record without email" do
    user = User.new
    user.name = 'testing'
    assert_not user.save, "email can't be blank"
  end

  test "should not save user record without password" do
    user = User.new
    user.name = 'testing'
    user.email = 'test@gmail.com'
    assert_not user.save, "password can't be blank"
  end

  test "should not save user record if password and password_confirmation does not match" do
    user = User.new
    user.name = 'testing'
    user.email = 'test@gmail.com'
    user.password = 'testing123'
    user.password = 'testing'
    assert_not user.save, "password confirmation does not match"
  end

  test "should get edit template" do
    get :edit, id: @user.id 
    assert_response :success
  end

  test 'should update the user record' do
    put :update, id: @user.id, user: { name: 'Test User', email: 'test@gmail.com', is_active: 'false',
                                         password: 'paritosh123', password_confirmation: 'paritosh123', role: 'Staff' }
    @user.reload
    assert_equal 'Test User', @user.name
    assert_equal false, @user.is_active
    assert_equal "test@gmail.com", @user.email
    assert_equal "Staff", @user.role
  end
end
