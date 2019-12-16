require 'test_helper'

class PettyCashTest < ActiveSupport::TestCase
  setup do
    @petty_cash = FactoryGirl.create :petty_cash
  end

  test 'should transaction amount, transaction_type, date Must be present' do
    petty_cash = PettyCash.new
    refute petty_cash.valid?
    assert_not_nil petty_cash.errors
  end
end
