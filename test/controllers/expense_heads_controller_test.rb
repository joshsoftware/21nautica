require 'test_helper'

class ExpenseHeadsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @expense_head = FactoryGirl.create :expense_head
    @petty_cash = FactoryGirl.create :petty_cash
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:expense_head)
    assert_response :success
  end

  test 'should create expense_head' do
    assert_difference 'ExpenseHead.count', +1 do
      post :create, expense_head: { name: 'Container_1',
                                    is_related_to_truck: true }
      assert_redirected_to action: 'index'
    end
  end

  test 'should Update expense_head name and truck' do
    assert_no_difference 'ExpenseHead.count' do
      put :update, expense_head: { name: 'Truck_2',
                                   is_related_to_truck: false }, id: @expense_head.id
      @expense_head.reload
      assert_equal 'Truck_2', @expense_head.name
      assert_equal false, @expense_head.is_related_to_truck
    end
  end

  test 'Should update is_active to false' do
    assert_no_difference 'ExpenseHead.count', +1 do
      put :update, expense_head: { is_active: false }, id: @expense_head.id
      @expense_head.reload
      assert_equal false, @expense_head.is_active
    end
  end
end
