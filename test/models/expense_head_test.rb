require 'test_helper'

class ExpenseHeadTest < ActiveSupport::TestCase
  setup do
    @expense_head = FactoryGirl.create :expense_head
  end

  test 'Should name is presenset' do
    expense_head = ExpenseHead.create
    assert_not expense_head.save
    assert expense_head.errors.messages[:name].include?("can't be blank")
  end

  test 'should is_active true  when expense_head is created' do
    assert_equal true, @expense_head.is_active
  end
end
