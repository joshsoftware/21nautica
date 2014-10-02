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

  test "should update export" do
    xhr :post, :update, { id: @export.id,
                    columnName: 'Equipment',
                    value: '40'
                    }
    @export.reload
    assert_equal '40', @export.equipment
  end

  test "should not create export with duplicate R/O number" do
    assert_no_difference('Export.count') do
      post :create, export: {export_type: 'TBL', equipment: '20', shipping_line: 'line', quantity: '20', release_order_number: '12345678'}
    end
    assert_template :new
  end

end
