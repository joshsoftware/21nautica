require 'test_helper'

class RemarksControllerTest < ActionController::TestCase
  # setup do
  #   @user = FactoryGirl.create :user
  #   @remark = FactoryGirl.create :remark
  #   sign_in @user
  # end

  test "should get index" do
    get :index
    byebug
    assert_response :success
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test 'should create new bill record' do
  #   assert_difference('Bill.count') do
  #     post :create, bill_attr
  #   end
  #   assert_equal 'Bill created sucessfully', flash[:notice]
  #   assert_redirected_to bills_path
  # end

  # test "should get edit template" do
  #   get :edit, id: @bill.id 
  #   assert_response :success
  # end

  # test "should not save bill" do
  #   assert_no_difference('Bill.count') do
  #     bill = Bill.new
  #     assert_not bill.save, 'Saved the bill without bill_items'
  #   end
  # end

  # test 'should update the bill record' do
  #   put :update, id: @bill.id, bill: { bill_number: 'H32', bill_date: '26-10-2015', remark: 'testing update'}
  #   @bill.reload
  #   assert_equal 'H32', @bill.bill_number
  #   assert_equal '26-10-2015', @bill.bill_date.strftime("%d-%m-%Y")
  #   assert_equal 'testing update', @bill.remark

  #   assert_equal 1, @bill.bill_items.count
  #   assert_equal 'Import', @bill.bill_items.last.item_type
  #   assert_equal 'Agency Fee', @bill.bill_items.last.charge_for
  #   assert_equal 1, @bill.bill_items.last.quantity
  #   assert_equal 1000, @bill.bill_items.last.rate
  #   assert_equal 1000, @bill.bill_items.last.line_amount

  #   assert_equal 1000, @bill.value
  # end
end
