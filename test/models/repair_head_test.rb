require 'test_helper'

class RepairHeadTest < ActiveSupport::TestCase
  setup do
    @repair_head = FactoryGirl.create :repair_head
  end

  test 'should not create repair head with same name' do
    name = RepairHead.first.name
    repair_head = RepairHead.new(name:name)
    refute repair_head.valid?
    assert_not_nil repair_head.errors[:name]
  end
end
