require 'test_helper'

class ExportItemsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
  end

  test "should create export_item" do
    export = FactoryGirl.create :export

    assert_difference('ExportItem.count') do
      post :create, {container: 'test_container', location: 'location2', date_of_placement: Date.yesterday, export_id: export.id}
    end
    assert_response :success
  end

  test "should not create export_item with future date" do
  end

end
