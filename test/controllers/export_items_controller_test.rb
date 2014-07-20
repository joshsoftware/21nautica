require 'test_helper'

class ExportItemsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should create export_item" do
    export = FactoryGirl.create :export

    assert_difference('ExportItem.count') do
      post :create, {container: 'test_container', location: 'location2', date_of_placement: Date.today, export_id: export.id}
    end
    assert_response :success
  end

end
