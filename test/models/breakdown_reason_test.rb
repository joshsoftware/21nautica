require 'test_helper'

class BreakdownReasonTest < ActiveSupport::TestCase
  setup do
    @breakdown_reason = FactoryGirl.create :breakdown_reason
  end

  test 'Should name is present' do
    breakdown_reason = BreakdownReason.create
    assert_not breakdown_reason.save
    assert breakdown_reason.errors.messages[:name].include?("Name can't be blank")
  end

  test 'Should not accept duplicate name' do
    breakdown_reason = BreakdownReason.create name: 'break   drum'
    assert_not breakdown_reason.save
    assert breakdown_reason.errors.messages[:name].include?('Reason is already present')
  end

end
