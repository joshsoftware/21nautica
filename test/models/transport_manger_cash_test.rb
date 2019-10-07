require 'test_helper'

class TransportMangerCashTest < ActiveSupport::TestCase
  setup do
    @transport_manger_cash = FactoryGirl.create :transport_manger_cash
    @import_item = FactoryGirl.create :import_item
    @import = FactoryGirl.create :import
    @truck = FactoryGirl.create :truck
  end

  test 'should transaction amount, import_item_id Must be present' do
    transport_manger_cash = TransportMangerCash.new(transaction_type: 'Withdrawal')
    assert_not transport_manger_cash.save
    assert transport_manger_cash.errors.messages[:transaction_amount]
                                .include?("can't be blank")
    assert transport_manger_cash.errors.messages[:import_item_id]
                                .include?("can't be blank")
  end
end
