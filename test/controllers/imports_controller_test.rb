require 'test_helper'

class ImportsControllerTest < ActionController::TestCase
  setup do
    @import = FactoryGirl.create :import
  end

  # commenting because import is not implement
  #test "should get index" do
  #  get :index
  #  assert_response :success
  #  assert_not_nil assigns(:imports)
  #end

end
