require 'test_helper'

class PettyCashTest < ActiveSupport::TestCase
  setup do
    @petty_cash = FactoryGirl.create :petty_cash
  end

  test "should transaction amount, transaction_type, date Must be present" do
    petty_cash = PettyCash.new 
    assert_not petty_cash.save 
    assert petty_cash.errors.messages[:transaction_amount].include?("can't be blank")
    assert petty_cash.errors.messages[:transaction_type].include?("can't be blank")
    assert petty_cash.errors.messages[:date].include?("can't be blank")    
  end


end