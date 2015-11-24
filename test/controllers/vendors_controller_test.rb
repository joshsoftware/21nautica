require 'test_helper'

class VendorsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user, role: 'Admin')
    @vendor = FactoryGirl.create(:vendor)
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

  test 'should create new vendor record' do
    assert_difference('Vendor.count') do
      post :create, vendor: FactoryGirl.attributes_for(:vendor, name: 'test', vendor_type: ['',"transporter", "icd", "shipping_line"])
    end
    assert_redirected_to vendors_path
  end

  test "should not save vendor record without type" do
    assert_no_difference('Vendor.count') do
      vendor = Vendor.new
      vendor.name = 'testing'
      assert_not vendor.save, 'Invalid vendor type'
    end
  end

  test "should not save vendor record without name" do
    assert_no_difference('Vendor.count') do
      vendor = Vendor.new
      vendor.vendor_type = 'icd, shipping_line'
      assert_not vendor.save, 'Invalid vendor type'
    end
  end

  test "should get edit template" do
    get :edit, id: @vendor.id 
    assert_response :success
  end

  test 'should update the bill record' do
    put :update, id: @vendor.id, vendor: { name: 'ABCD vendor', "vendor_type"=>["", "shipping_line", "final_clearing_agent"] }
    @vendor.reload
    assert_equal 'ABCD vendor', @vendor.name
    assert_equal "shipping_line,final_clearing_agent", @vendor.vendor_type
  end

end
