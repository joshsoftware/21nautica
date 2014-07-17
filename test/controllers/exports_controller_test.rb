require 'test_helper'

class ExportsControllerTest < ActionController::TestCase
  setup do
    @export = FactoryGirl.create :export
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exports)
  end

end
