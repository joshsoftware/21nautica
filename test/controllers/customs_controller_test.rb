require "test_helper"
require "minitest/autorun"

class CustomsControllerTest < ActionController::TestCase
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
    assert_select 'table#customs_table', :count => 1
  end

  test "should update dates" do
    xhr :post, :update, import: {
                    entry_number: "1231",
                    entry_type: "im4",
                    rotation_number: "121212"
                    }, id: @import.id
    xhr :post, :retainStatus, {id: @import.id}
    @import.reload
    assert_equal "1231", @import.entry_number
  end

  test "should fetch custom modal" do
    xhr :get, :fetch_custom_modal, id: @import.id
    assert_template partial: "customs/_custom_modal"
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
