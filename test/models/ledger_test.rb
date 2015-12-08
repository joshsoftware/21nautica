require 'test_helper'

class LedgerTest < ActiveSupport::TestCase
  setup do
    @inv_ledger = FactoryGirl.create(:invoice_ledger)
  end

  test 'should update the ledger if invoice made' do
    assert_equal 'Invoice', @inv_ledger.voucher_type
    assert_equal 1000, @inv_ledger.amount
    assert_equal 0, @inv_ledger.received
  end

  test 'should update the ledger if payment made' do
    @payment = FactoryGirl.create(:received_ledger, customer: @inv_ledger.customer)
    @inv_ledger.reload
    assert_equal 'Payment', @payment.voucher_type
    assert_equal 500, @inv_ledger.received
    assert_equal 500, @payment.amount
    assert_equal 500, @payment.received
    assert_equal @inv_ledger.customer, @payment.customer
  end

end
