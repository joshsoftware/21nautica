require 'test_helper'
require "minitest/autorun"

class ImportsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @import = FactoryGirl.create :import
  end

  test "should not save import with duplicate bl_number" do
    assert_no_difference('Import.count') do
      post :create, import: {bl_number: 'BL1', to: "momabasa", from: "k", 
        shipping_line: "Maersk", estimate_arrival: "06-10-2014", equipment: "20GP", 
        quantity: "1", description: "tfy", import_items_attributes: {"1410153969411" => {container_number: "1"}}}
    end 
  end

  test "should create new import" do
    assert_difference('Import.count') do
      post :create, import: {bl_number: 'BL2', to: "momabasa", from: "k", 
        shipping_line: "Maersk", estimate_arrival: "06-10-2014", equipment: "20GP", 
        quantity: "1", description: "tfy", import_items_attributes: {"1410153969411" => {container_number: "1"}}}
    end 
    assert_redirected_to imports_path
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:imports)
    assert_response :success
    assert_select 'table tr', :count => 1
  end

  test "should update work_order_number" do
    xhr :post, :update, { id: @import.id,
                    columnName: 'Work Order Number',
                    value: 'WON'
                    } 
    @import.reload
    assert_equal 'WON', @import.work_order_number
  end

  test "should update import status" do
    get :index
    assert_response :success
    #assert_select 'form select option', :count => 2
    assert_raises(AASM::InvalidTransition) do
      xhr :post, :updateStatus, import: {status: "ready_to_load", "remarks"=>"okay"}, id: @import.id
    end 
    xhr :post, :updateStatus, import: {status: "original_documents_received", "remarks"=>"okay"}, id: @import.id
    xhr :post, :updateStatus, import: {status: "container_discharged", "remarks"=>"okay"}, id: @import.id
    xhr :post, :updateStatus, import: {status: "ready_to_load", "remarks"=>"okay"}, id: @import.id
    assert_template :updateStatus
    @import.reload
    assert_select 'table tr', :count => 0
  end
end
