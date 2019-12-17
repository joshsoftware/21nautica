# frozen_string_literal: true

require "test_helper"

class RemarksControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    @remark = FactoryGirl.create :remark
    sign_in @user
  end

  test "should get index with import remarks" do
    model_info = {}
    model_info[:remark] = {model_type: "import", model_id: (FactoryGirl.create :import).id}
    get :index, model_info
    assert_response :success
    assert_equal((JSON.parse response.body).keys, ["remarks"])
  end

  test "should get index with import item remarks" do
    model_info = {}
    import = FactoryGirl.create :import
    import_item = FactoryGirl.create :import_item, import_id: import.id
    model_info[:remark] = {model_type: "import_item", model_id: import_item.id}
    get :index, model_info
    assert_response :success
    assert_equal((JSON.parse response.body).keys, ["order_remarks", "container_remarks"])
  end  

  test "should create new remark record" do
    remark_params = { model_type: "import", model_id: (FactoryGirl.create :import).id, desc: "test", category: "internal", date: "2019-09-19" }
    assert_difference("Remark.count") do
      xhr :post, :create, {remark: remark_params}
    end
  end
end
