require 'test_helper'

class FuelEntriesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @fuel_entry = FactoryGirl.create :fuel_entry, purchased_dispensed: "purchase"
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:fuel_entry)
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should create fuel entry ' do
    assert_difference "FuelEntry.count" do
      post :create, fuel_entry: { date: Date.current,
                                            purchased_dispensed: 'purchase',
                                            quantity: 2,
                                            cost: 39,
                                            truck_id: 9,
                                            rate: 2,
                                            is_adjustment: false
                                          }
      assert_redirected_to action: "index"
      end
    end
end
