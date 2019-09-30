require 'test_helper'

class JobCardsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create :user, role: 'Admin'
    sign_in @user
    @truck = FactoryGirl.create :truck
    @job_card = FactoryGirl.create :job_card
  end

  test 'should get new' do
    get :new
    assert_not_nil assigns(:job_card)
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_not_nil assigns(:job_cards)
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
    assert_difference 'JobCard.count' do
      post :create, job_card: { number: 'NM!123',
                                truck_id: @truck.id,
                                job_card_details_attributes:
                                 [repair_head_id: @job_card.job_card_details.first.repair_head_id] }
      assert_redirected_to action: 'index'
    end
  end
  test 'should update job_card' do
    assert_no_difference 'JobCard.count' do
      put :update, job_card: { number: 'NM!127',
                               truck_id: @truck.id,
                               job_card_details_attributes:
                                [repair_head_id: @job_card.job_card_details.first.repair_head_id] }, id: @job_card.id
      @job_card.reload
      assert_equal 'NM!127', @job_card.number
    end
  end

  test 'should update job_card_detail' do
    assert_no_difference '@job_card.job_card_details.count' do
      repair_head = FactoryGirl.create :repair_head, name: 'dyanama'
      job_card_detail = @job_card.job_card_details.last
      put :update, job_card: { number: 'NM!127',
                               truck_id: @truck.id,
                               job_card_details_attributes:
                                [id: job_card_detail.id,
                                 repair_head_id: repair_head.id ] }, id: @job_card.id
      @job_card.reload
      assert_equal repair_head.id, @job_card.job_card_details.last.repair_head_id
    end
  end

  test 'should delete job_card_detail' do
    assert_difference 'JobCardDetail.count', -1 do
      job_card_detail = @job_card.job_card_details.last
      put :update, job_card: { number: 'NM!127',
                               truck_id: @truck.id,
                               job_card_details_attributes:
                                [id: job_card_detail.id,
                                 repair_head_id: job_card_detail.repair_head_id,
                                 _destroy: 1] }, id: @job_card.id
    end
  end
end
