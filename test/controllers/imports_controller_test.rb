require "test_helper"
require "minitest/autorun"

class ImportsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @import = FactoryGirl.create :import
    @customer = FactoryGirl.create :customer
  end

  test "should not save import with duplicate bl_number" do
    assert_no_difference('Import.count') do
      post :create, import: {bl_number: "BL1", to: "momabasa", from: "k",
        shipping_line: "Maersk", estimate_arrival: "06-10-2014", equipment: "20GP",
        quantity: "1", description: "tfy", import_items_attributes: {"1410153969411" => {container_number: "1"}}}
    end
  end

  test "should create new import" do
    assert_difference('Import.count') do
      post :create, import: {bl_number: "BL_123_123", to: "momabasa", from: "k", customer_id: @customer.id,
        estimate_arrival: "06-10-2014", equipment: "20GP",
        quantity: "1", description: "tfy", rate_agreed: 2000, weight: 30,
        bl_received_type: "copy", work_order_number: 1234,
        import_items_attributes: {"1410153969411" => {container_number: "con1"}}}
    end
    assert_redirected_to imports_path
  end

  test "should get index" do
    destination = 'location 2'
    FactoryGirl.create :import
    count = Import.not_ready_to_load.custom_shipping_dates_not_present.where(to: destination).count
    get :index, {destination: destination}
    assert_not_nil assigns(:imports)
    assert_response :success
    assert_template layout: "application"
    assert_select 'table#imports_table tr', count
  end

  test "should get new" do
    get :new
    assert_response :success
  end
end
