require "test_helper"
require "minitest/autorun"

class ShippingsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @import = FactoryGirl.create :import
    @customer = FactoryGirl.create :customer
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:imports)
    assert_response :success
    assert_template layout: "application"
    assert_select 'table#shippings_table', :count => 1
  end

  test "should update dates" do
    xhr :post, :update, { id: @import.id,
                    bl_received_at: Date.today,
                    charges_received_at: Date.today
                    }
    xhr :post, :retainStatus, {id: @import.id}
    @import.reload
    assert_equal Date.today, @import.bl_received_at
  end

  test "should update import status to ready_to_load if work_order_number present" do
    get :index
    assert_response :success
    @import.update(work_order_number: "wo1")
    xhr :post, :updateStatus, import: {status: "original_documents_received", "remarks"=>"okay"}, id: @import.id
    xhr :post, :updateStatus, import: {status: "container_discharged", "remarks"=>"okay"}, id: @import.id
    xhr :post, :updateStatus, import: {status: "ready_to_load", "remarks"=>"okay"}, id: @import.id
    assert_template :updateStatus
    @import.reload
    assert_equal "ready_to_load", @import.status
    assert_select "table tr", :count => 0
  end
end
