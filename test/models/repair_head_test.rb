require 'test_helper'

class RepairHeadTest < ActiveSupport::TestCase
  setup do
    @repair_head = FactoryGirl.create :repair_head, name: 'stater'
  end

  test 'should not create repair head with same name' do
    repair_head = RepairHead.new
    repair_head.name = 'stater'
    assert_not repair_head.save
    assert repair_head.errors.messages[:name].include?('Repair_Head with same name already exists')
    byebug
  end
end
