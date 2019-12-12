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
    @import_item1.truck_id = (FactoryGirl.create :import_item1).id
    @import_item2.truck_id = (FactoryGirl.create :import_item1).id
    # @import_item2.save!
    # @import_item1.save!
    get :index
    assert_response :success
    assert_not_nil assigns(:import_items)
    assert_select 'table.table' , :count => 1
  end

  test "should update import item status" do
    get :index
    assert_response :success
    @import_item1.import_id = (FactoryGirl.create :import_with_dates).id
    @import_item1.save!
    truck = FactoryGirl.create :truck

    xhr :post, :updateStatus, import_item: {status: "allocate_truck", truck_id: truck.id}, id: @import_item1.id
    assert_equal "truck_allocated", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: { status: "ready_to_load",
                exit_note_received: "1", expiry_date: Date.today.to_s
              }, id: @import_item1.id
    assert_equal "ready_to_load", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: {status: "loaded_out_of_port", "remarks"=>"okay"}, id: @import_item1.id
    assert_equal "loaded_out_of_port", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: {status: "arrived_at_border"}, id: @import_item1.id
    assert_equal "arrived_at_border", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: {status: "departed_from_border"}, id: @import_item1.id
    assert_equal "departed_from_border", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: {status: "arrived_at_destination"}, id: @import_item1.id
    assert_equal "arrived_at_destination", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: {status: "truck_released", return_status: "Empty Returned"}, id: @import_item1.id
    assert_equal "delivered", @import_item1.reload.status
    assert_template :updateStatus
  end

  test "can not change status to truck allocated if truck is not allocated" do
    get :index
    assert_response :success
    @import_item1.import_id = (FactoryGirl.create :import_with_dates).id
    @import_item1.save!
    truck = FactoryGirl.create :truck
    exp_resp = "$('#statusModal .alert').remove();\n$('#statusModal .modal-body').append(\"<div class= 'alert alert-danger'> Add Truck Number first !</div>\")\n"
    xhr :post, :updateStatus, import_item: {status: "allocate_truck"}, id: @import_item1.id
    assert_equal exp_resp, response.body
  end

  test "can not loaded_out_of_port if all docs not received" do
    truck = FactoryGirl.create :truck
    @import_item1.import_id = (FactoryGirl.create :import, entry_type: "im4").id
    @import_item1.save!
    xhr :post, :updateStatus, import_item: {status: "allocate_truck", truck_id: truck.id}, id: @import_item1.id
    assert_equal "truck_allocated", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: { status: "ready_to_load",
                exit_note_received: "1", expiry_date: Date.today.to_s
              }, id: @import_item1.id
    assert_equal "ready_to_load", @import_item1.reload.status
    xhr :post, :updateStatus, import_item: {status: "loaded_out_of_port", "remarks"=>"okay"}, id: @import_item1.id
    exp_resp = "$('#statusModal .alert').remove();\n$('#statusModal .modal-body').append(\"<div class= 'alert alert-danger'> All documents are not received yet for this order</div>\")\n"
    assert_equal exp_resp, response.body
  end  

  test "should get history" do
    get :history
    assert_template :history
    assert_response :success
  end

  test "should get data on json request to history" do
    @import_item1.update_columns(status: "delivered", truck_id: (FactoryGirl.create :import_item1).id,
      interchange_number: "abcd")
    @import_item2.update_columns(status: "delivered", truck_id: (FactoryGirl.create :import_item1).id,
      interchange_number: "abcde")
    @import_item2.save!
    @import_item1.save!
    data = ImportItem.where.not(interchange_number: nil).as_json
    xhr :get, :history, {searchValue: "bl"}
    assert_response :success
  end

  test "should get empty containers list" do
    @import_item1.update_columns(interchange_number: nil, truck_id: (FactoryGirl.create :import_item1).id )
    @import_item2.update_columns(interchange_number: nil, truck_id: (FactoryGirl.create :import_item1).id )
    get :empty_containers
    assert_response :success
    assert_not_nil assigns(:import_items)
    assert_response :success
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

  test "Should update_empty_container " do
    import_item = FactoryGirl.create :import_item, status: "delivered"
    xhr :post, :update_empty_container, import_item: { interchange_number: 'abcd', close_date: Date.today.to_s}, id: import_item.id
    import_item.reload
    assert_equal 'abcd', import_item.interchange_number
  end

end

