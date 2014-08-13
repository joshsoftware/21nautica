require 'test_helper'

class ExportsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @export = FactoryGirl.create :export
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:exports)
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_not_nil assigns(:export)
    assert_response :success
  end

  test "should create export" do
    assert_difference('Export.count') do
      post :create, export: {export_type: 'TBL', equipment: '20', quantity: '20', shipping_line: 'line', release_order_number: '12345'}
    end
    assert_redirected_to exports_path
  end

end
