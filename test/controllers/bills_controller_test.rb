require 'test_helper'

class BillsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    @bill = FactoryGirl.create :bill
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bills)
    assert_template layout: "application"
    assert_select 'table#bills_table', 1
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test 'should create new bill record' do
    assert_difference('Bill.count') do
      post :create, bill_attr
    end
    assert_equal 'Bill created sucessfully', flash[:notice]
    assert_redirected_to bills_path
  end

  test "should get edit template" do
    get :edit, id: @bill.id 
    assert_response :success
  end

  test "should not save bill" do
    assert_no_difference('Bill.count') do
      bill = Bill.new
      assert_not bill.save, 'Saved the bill without bill_items'
    end
  end

  test 'should update the bill record' do
    put :update, id: @bill.id, bill: { bill_number: 'H32', bill_date: '26-10-2015', remark: 'testing update'}
    @bill.reload
    assert_equal 'H32', @bill.bill_number
    assert_equal '26-10-2015', @bill.bill_date.strftime("%d-%m-%Y")
    assert_equal 'testing update', @bill.remark

    assert_equal 1, @bill.bill_items.count
    assert_equal 'Import', @bill.bill_items.last.item_type
    assert_equal 'Agency Fee', @bill.bill_items.last.charge_for
    assert_equal 1, @bill.bill_items.last.quantity
    assert_equal 1000, @bill.bill_items.last.rate
    assert_equal 1000, @bill.bill_items.last.line_amount

    assert_equal 1000, @bill.value
  end

  test 'should delete the ledger' do
    get :delete_ledger, id: @bill
    assert_redirected_to readjust_path(@bill.vendor_id)
  end

  def bill_attr
    @vendor = FactoryGirl.create :vendor  
    @import = FactoryGirl.create :import
    @import_item1 = FactoryGirl.create :import_item
    @import_item1.import_id = @import.id
    bill_item = FactoryGirl.attributes_for(:bill_item, item_type: 'Import', item_for: "container", item_number: @import_item1.container_number, 
    charge_for: "ICD Charges", quantity: 1, rate: 900.0, line_amount: 900.0,  activity_id: @import_item1.import.id, activity_type: "Import")
    {
      bill: FactoryGirl.attributes_for(:bill, bill_number: 'ABCD1', bill_date: '2015-10-20', vendor_id: @vendor.id, value: 900, remark: 'testing', created_by_id: @user.id, approved_by_id: @user.id).merge("bill_items_attributes" => {"0" => bill_item})
    }
  end

end
