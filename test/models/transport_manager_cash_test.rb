require 'test_helper'

class TransportManagerCashTest < ActiveSupport::TestCase
  setup do
    @transport_manager_cash = FactoryGirl.create :transport_manager_cash
    @import_item = FactoryGirl.create :import_item
    @import = FactoryGirl.create :import
    @truck = FactoryGirl.create :truck
  end

  test 'should transaction amount, import_item_id Must be present' do
    transport_manager_cash = TransportManagerCash.new(transaction_type: 'Withdrawal')
    assert_not transport_manager_cash.save
    assert transport_manager_cash.errors.messages[:transaction_amount]
                                .include?("can't be blank")
    assert transport_manager_cash.errors.messages[:import_item_id]
                                .include?("can't be blank")
  end
end
