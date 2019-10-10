require 'test_helper'

class TransportManagerCashesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @transport_manager_cash = FactoryGirl.create :transport_manager_cash
    @import_item = FactoryGirl.create :import_item
    @truck = FactoryGirl.create :truck
    @import = FactoryGirl.create :import
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:transport_manager_cash)
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_not_nil assigns(:transport_manager_cashes)
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @transport_manager_cash.id
    assert_not_nil assigns(:transport_manager_cash)
    assert_response :success
  end

  test 'should  create Transport Manger Cash' do
    assert_difference 'TransportManagerCash.count', 1 do
      post :create, transport_manager_cash: { import_item_id: @import_item.id,
                                             transaction_type: 'Withdrawal',
                                             transaction_amount: '2333' }
      assert_redirected_to action: 'index'
    end
  end

  test 'should  Edit Transport Manger Cash' do
    import_item = FactoryGirl.create :import_item
    assert_no_difference 'TransportManagerCash.count' do
      put :update, transport_manager_cash: { import_item_id: import_item.id,
                                            transaction_amount: '2333',
                                            transaction_type: 'Withdrawal' }, id: @transport_manager_cash
      assert_redirected_to action: 'index'
    end
  end
end
