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
    assert_difference 'PettyCash.count', +4 do
      post :create, petty_cash: {account_type:'Bank','1'=>{description: "Paid to", transaction_amount: 200.0, transaction_type: "Deposit" }, '2'=>{description: "Paid to", transaction_amount: 200.0, transaction_type: "Deposit" }}
      post :create, petty_cash: {account_type:'Cash','1'=>{description: "Paid to", transaction_amount: 200.0, transaction_type: "Deposit" }, '2'=>{description: "Paid to", transaction_amount: 200.0, transaction_type: "Deposit" }}
      assert_redirected_to action: "index"
      assert_response :redirect
    end
  end
end
