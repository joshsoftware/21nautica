require 'test_helper'
require "minitest/autorun"
class ImportItemsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @import = FactoryGirl.create :import
    @import_item1 = FactoryGirl.create :import_item1
    @import_item2 = FactoryGirl.create :import_item2
    @import_item3 = FactoryGirl.create :import_item3
    @vendor = FactoryGirl.create :vendor
    @import.status = "ready_to_load"
    @import.save
    @import_item1.import = @import
    @import_item2.import = @import
    @import_item3.import = @import
  end

  test "should get index" do
    @import_item1.status = "under_loading_process"
    @import_item2.status = "delivered"
    @import_item2.save!
    @import_item1.save!
    get :index
    assert_response :success
    assert_not_nil assigns(:import_items)
    assert_select 'table tr' , :count => 1
  end

  test "should update import item status" do
    get :index
    assert_response :success
    @import_item1.save!
    assert_raises(AASM::InvalidTransition) do
      xhr :post, :updateStatus, import_item: {status: "loaded_out_of_port", "remarks"=>"okay"}, id: @import_item1.id
    end
    @import_item1.truck_number = 'TR2345'
    xhr :post, :updateStatus, import_item: {status: "allocate_truck", "remarks"=>"okay", truck_number: 'TR1'}, id: @import_item1.id
    xhr :post, :updateStatus, import_item: {status: "loaded_out_of_port", "remarks"=>"okay"}, id: @import_item1.id
    xhr :post, :updateStatus, import_item: {status: "arrived_at_malaba", "remarks"=>"okay"}, id: @import_item1.id
    xhr :post, :updateStatus, import_item: {status: "departed_from_malaba", "remarks"=>"okay"}, id: @import_item1.id
    xhr :post, :updateStatus, import_item: {status: "arrived_at_kampala", "remarks"=>"okay"}, id: @import_item1.id
    xhr :post, :updateStatus, import_item: {status: "truck_released", "remarks"=>"okay"}, id: @import_item1.id
    assert_template :updateStatus
  end

  test "should get history" do
    get :history
    assert_template :history
    assert_response :success
  end

  test "should get data on json request to history" do
    @import_item1.status = "delivered"
    @import_item2.status = "delivered"
    @import_item2.save!
    @import_item1.save!
    data = ImportItem.where(status: "delivered").as_json
    get :history, format: :json
    assert_response :success
    assert_equal JSON.parse(response.body)['data'], data
  end

  test "should get empty containers list" do
    @import_item1.status = "delivered"
    @import_item2.status = "delivered"
    @import_item1.after_delivery_status = nil
    @import_item2.after_delivery_status = "export_reuse"
    @import_item1.save!
    @import_item2.save!
    get :empty_containers
    assert_response :success
    assert_not_nil assigns(:import_items)
    assert_select 'table tr' , :count => 1
  end

  test "should update truck number " do
    xhr :post, :update, { id: @import_item1.id, columnName: 'Truck Number',
                          value: 'TR23'}
    @import_item1.reload
    assert_equal 'TR23', @import_item1.truck_number
  end

  test "should update the context" do
    xhr :post, :updateContext, import_item: {"context"=>"tr234", "transporter_name"=>"Trans1"} ,
                            "after_delivery"=>"empty_return", id: @import_item1.id
    @import_item1.reload
    assert_equal "Empty return" ,@import_item1.after_delivery_status
    assert_equal "Truck Number: tr234 , Transporter: Trans1 , " +
      Date.today.strftime("%d-%m-%Y") , @import_item1.context

    xhr :post, :updateContext, import_item: {"context"=>"Cust1"} ,
                            "after_delivery"=>"export_reuse", id: @import_item2.id
    @import_item2.reload
    assert_equal "Export reuse" ,@import_item2.after_delivery_status
    assert_equal "Customer Name: Cust1 , " +
      Date.today.strftime("%d-%m-%Y") , @import_item2.context


    xhr :post, :updateContext, import_item: {"context"=>"Yard1"} ,
                            "after_delivery"=>"drop_off", id: @import_item3.id
    @import_item3.reload
    assert_equal "Drop off" ,@import_item3.after_delivery_status
    assert_equal "Yard Name: Yard1 , " +
      Date.today.strftime("%d-%m-%Y") , @import_item3.context
  end

  test "should not update truck number to non-free truck" do
    @import_item1.truck_number = 'TR23'
    @import_item1.save
    xhr :post, :update, { id: @import_item2.id, columnName: 'Truck Number',
                          value: 'TR23'}
    @import_item2.reload
    assert_not_equal 'TR23', @import_item2.truck_number
  end

  test "should update transporter_name" do
    xhr :post, :update, { id: @import_item2.id, columnName: 'Transporter Name',
                          value: 'Mansons'}
    @import_item2.reload
    assert_equal 'Mansons', @import_item2.transporter_name
  end

end

