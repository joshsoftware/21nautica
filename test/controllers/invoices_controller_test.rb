require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user
    sign_in @user
    @invoice = FactoryGirl.create :invoice
  end

  test "should get index" do
    get :index
    assert_not_nil assigns(:invoices)
    assert_response :success
  end

  test "should edit invoice" do
    xhr :get, :edit, {id: @invoice.id}
    assert_not_nil assigns(:invoice)
    assert_response :success
  end

  test "should update invoice" do
    xhr :post, :update, { invoice: {amount: '200', number: '022015032', 
      document_number: 'SE-265', particulars_attributes: {'1423073800705' => {name: 
        'Clearing Charges', rate: '200', quantity: '1', subtotal: '200', _destroy: 'false'}}}, 
        id: @invoice.id}
    @invoice.reload
    assert_equal 200, @invoice.amount
    assert_equal 1, @invoice.particulars.count
    assert_equal 200, @invoice.particulars.first.rate
  end

  test "should get new additional invoice" do
    xhr :get, :new_additional_invoice, {id: @invoice.id}
    assert_not_nil assigns(:invoice)
    assert_response :success
  end

  test "should create additional invoice" do
  end

end
