require 'test_helper'

class JobCardsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @repair_head = FactoryGirl.create :repair_head
    @truck = FactoryGirl.create :truck
    @job_card = FactoryGirl.create :job_card

  end

  test "should get new" do
    get :new
    assert_not_nil assigns(:job_card)
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_not_nil assigns(:job_card)
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @job_card.id
    assert_not_nil assigns(:job_card)
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @job_card.id
    assert_not_nil assigns(:job_card)
    assert_response :success
  end 

  test 'should create Job Card' do
    assert_difference "JobCard.count" do
      post :create, job_card:{ number:'qqweq', truck_id: @truck.id, job_card_details_attributes: [repair_head_id: 12] } 
      assert_redirected_to action: "index"
    end
  end

  # test 'should update job_card' do 
  #   assert_no_difference "JobCard.count" do
  #     put :update, job_card:{ number:'qq', truck_id: @truck.id, job_card_details_attributes: [repair_head_id: 13 ] }, id: @job_card.id     
  #     @job_card.reload
  #     assert_equal 'qq', @job_card.number
  #   end
  # end

end
