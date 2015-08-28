require 'test_helper'

class BillOfLadingsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @bill_of_lading = FactoryGirl.create :bill_of_lading, bl_number: 'BL4'
    @bill_of_lading1 = FactoryGirl.create :bill_of_lading1, bl_number: 'BL323'
    @movement = FactoryGirl.create :movement
    @export_item = FactoryGirl.create :export_item
    @export = FactoryGirl.create :export
    @customer = FactoryGirl.create :customer
    @export.customer = @customer
    @export_item.export = @export
    @export_item.movement = @movement
    @movement.bill_of_lading = @bill_of_lading
    @export.save
    @movement.save
  end

  test "should search Bill of lading" do
    get :search, {"id"=>"BL4"}
    assert_not_nil assigns(:bl)
    assert_response :success
  end

  test "should update Bill Of Lading" do
    patch :update, "bill_of_lading"=>{"payment_ocean"=>"po6", "cheque_ocean"=>"cn5", 
    	"remarks"=>"Rm1"}, id: @bill_of_lading.id
    @bill_of_lading.reload
    assert_equal "po6", @bill_of_lading.payment_ocean
    assert_response :redirect
  end

  test "should render :search if bill of lading is not updated" do
  	patch :update, "bill_of_lading"=>{"payment_ocean"=>"po6", "cheque_ocean"=>"cn5", 
    	"remarks"=>"Rm1", "bl_number" => "BL323"}, id: @bill_of_lading1.id
    @bill_of_lading1.reload
    assert_not_equal "po6", @bill_of_lading1.payment_ocean
    assert_response :success
  end

end
