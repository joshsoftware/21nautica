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
    @bill_of_lading = FactoryGirl.create :bill_of_lading
    @customer = FactoryGirl.create :customer
    @movement.export_item = @export_item
    @export_item.export = @export
    @export.customer = @customer
    @export.save!
    @export_item.save!
    @movement.save!
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
    xhr :post, :retainStatus, {id: @movement.id}
    @movement.reload
    assert_equal 't2', @movement.truck_number
  end

  test "should update bl_number, assigns existing bill_of_lading if present" do
    xhr :post, :update, { id: @movement.id,
                           columnName: 'BL Number',
                           value: 'BL2'}
    xhr :post, :retainStatus, {id: @movement.id}
    @movement.reload
    assert_equal 'BL2', @movement.bl_number
  end

  test "should update bl_number, creates and assign new bill_of_lading if not present" do
     xhr :post, :update, { id: @movement.id,
                            columnName: 'BL Number',
                            value: 'BL3'}
     xhr :post, :retainStatus, {id: @movement.id}
     @movement.reload
     assert_equal 'BL3', @movement.bl_number
  end

  test "should update status for movement" do
    get :index
    assert_response :success
    assert_select 'table tr', :count => 1

    assert_raises(AASM::InvalidTransition) do
      xhr :post, :updateStatus, movement: {status: "document_handed", "remarks"=>"okay"}, id: @movement.id
    end
    xhr :post, :updateStatus, movement: {status: "arrived_malaba_border", "remarks"=>"okay"}, id: @movement.id
    xhr :post, :updateStatus, movement: {status: "crossed_malaba_border", "remarks"=>"okay"}, id: @movement.id
    xhr :post, :updateStatus, movement: {status: "order_released", "remarks"=>"okay"}, id: @movement.id
    xhr :post, :updateStatus, movement: {status: "arrived_port", "remarks"=>"okay"}, id: @movement.id
    xhr :post, :updateStatus, movement: {status: "document_handed", "remarks"=>"okay"}, id: @movement.id

    assert_template :updateStatus
    assert_select 'table tr', :count => 0
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

  test "should not create movement without truck number" do
    @export_item.export = @export
    @export_item.save
    assert_no_difference('Movement.count') do
      post :create, { id: 40,
                      movement: {
                                  point_of_discharge: 'Mundra',
                                  transporter_name: 'Mansons'},
                      export_item_id: @export_item.id
                    }
    end
  end

  test "should update movement truck number to blank" do
    xhr :post, :update, { id: @movement.id,
                    columnName: 'Truck Number',
                    value: ''
                    }
    xhr :post, :retainStatus, {id: @movement.id}
    @movement.reload
    assert_equal 't1', @movement.truck_number
  end

end
