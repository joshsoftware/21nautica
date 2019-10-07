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
    xhr :post, :update, import: {
                    bl_received_at: Date.today,
                    charges_received_at: Date.today
                    }, id: @import.id
    xhr :post, :retainStatus, {id: @import.id}
    @import.reload
    assert_equal Date.today, @import.bl_received_at
  end

  test "should fetch shipping modal" do
    xhr :get, :fetch_shipping_modal, id: @import.id
    assert_template partial: "shippings/_shipping_modal"
  end

  test "should update the column" do
    xhr :post, :update_column, {
                    id: @import.id,
                    columnName: "equipment",
                    value: "20GP"
                    }
    xhr :post, :retainStatus, {id: @import.id}
    @import.reload
    assert_equal "20GP", @import.equipment
  end

end
