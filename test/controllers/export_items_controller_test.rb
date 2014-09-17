require 'test_helper'

class ExportItemsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @export_item = FactoryGirl.create :export_item
    @export_item1 = FactoryGirl.create :export_item1
    @export = FactoryGirl.create :export
  end

  test "should create export_item" do
    assert_difference('ExportItem.count') do
      post :create, {container: 'test_container', location: 'location2', date_of_placement: Date.yesterday, export_id: @export.id}
    end
    assert_response :success
  end

  test "should not update export_item with future date" do
    assert_no_difference('@export_item.date_of_placement') do
    post :update, {id: @export_item.id,
                   date_of_placement: Date.tomorrow }
    end                  
  end

  test "should update container" do
    @export_item.export = @export
    @export_item1.export = @export
    @export_item.container = nil
    @export_item1.container = 'c1'
    @export_item.save 
    @export_item1.save
    
    post :updatecontainer, {id: @export_item1.id,
                            container: 'c2' }
    @export_item1.reload 
    assert_equal @export_item1.container,'c2'
    #assert_select "table tr", :count => 1 

    post :updatecontainer, {id: @export_item.id,
                            container: 'c' }
    @export_item.reload                       
    assert_equal @export_item.container,'c'
    #assert_equal "2", response.body               
  end 
end