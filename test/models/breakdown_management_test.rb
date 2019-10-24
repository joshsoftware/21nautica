require 'test_helper'

class BreakdownManagementTest < ActiveSupport::TestCase
  setup do
    @breakdown_management = FactoryGirl.create :breakdown_management
  end

  test 'Should name is present' do
    breakdown_management = BreakdownManagement.create
    assert_not breakdown_management.save
    assert breakdown_management.errors.messages[:location].include?("can't be blank")
    assert breakdown_management.errors.messages[:truck_id].include?("can't be blank")
    assert breakdown_management.errors.messages[:date].include?("can't be blank")
    assert breakdown_management.errors.messages[:breakdown_reason_id].include?("can't be blank")
  end

  test 'Should sending date be nil when parts_required is true' do
    @breakdown_management.parts_required = false
    assert @breakdown_management.save
    @breakdown_management.reload
    assert_equal false, @breakdown_management.parts_required
    assert_equal nil, @breakdown_management.sending_date
  end


end
