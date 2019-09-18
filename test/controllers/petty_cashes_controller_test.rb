require 'test_helper'

class PettyCashesControllerTest < ActionController::TestCase
  setup do
  	@user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @petty_cash = FactoryGirl.create :petty_cash
  end

  test "should get new" do
    get :new
    assert_not_nil assigns(:petty_cash)
    assert_response :success
  end

  test "should create petty_cash and update balance" do
    assert_difference 'PettyCash.count', +2 do
      post :create, petty_cash: {description: "Paid to", transaction_amount: 200.0, transaction_type: "Deposit" }
      post :create, petty_cash: {description: "Paid by", transaction_amount: 200.0, transaction_type: "Deposit" }
      assert_redirected_to action: "index"
      assert_response :redirect
      assert_equal 400.0, PettyCash.last.available_balance.to_f
    end
  end
  test "Should update petty cash with current date" do
    assert_difference 'PettyCash.count', do
      post :create, petty_cash: {description: "Paid to", transaction_amount: 200.0, transaction_type: "Deposit" }
      assert_equal Date.current, PettyCash.last.date
    end
end
