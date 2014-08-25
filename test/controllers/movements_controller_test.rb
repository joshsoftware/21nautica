  require 'test_helper'
  require 'mocha/test_unit'
  require "minitest/autorun"

class MovementsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @movement = FactoryGirl.create :movement
    @export = FactoryGirl.create :export
    @export_item = FactoryGirl.create :export_item
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get history" do
    get :history
    assert_response :success
  end
  
  test "should create movement" do
    @export_item.export = @export
    @export_item.save
    assert_difference('Movement.count') do
      post :create, { id: @movement.id ,
                      movement: {
                                  truck_number: 't12',
                                  point_of_discharge: 'Mundra',
                                  transporter_name: 'Mansons'},
                      export_item_id: @export_item.id
                    }                                
    end
    assert_response :success
  end

  test "should update movement" do
    xhr :post, :update, { id: @movement.id,
                    columnName: 'Truck Number',
                    value: 't2'
                    } 
    @movement.reload
    assert_equal 't2', @movement.truck_number        
  end

  test "should update status for movement" do
    
  end

  test "movement should not happen unless container assigned" do
    
  end

  status=["loaded",
            "under_customs_clearance",
            "enroute_mombasa",
            "arranging_shipping_order_and_vessel_nomination",
            "arrived_port"]

  status.each do |state|
    define_method("test_#{state}_alert") do
      @movement.status = state
      @movement.save
      time_now = Time.now + STATUS_CHANGE_DURATION[@movement.aasm.events.first.to_sym].day
      Time.stubs(:now).returns(time_now.getlocal)
      get :index  
      assert_select 'table>tbody' do |element|
        assert_select "tr[class=?]", "danger" 
      end
    end
  end

end
