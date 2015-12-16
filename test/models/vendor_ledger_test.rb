require 'test_helper'

class VendorLedgerTest < ActiveSupport::TestCase

  setup do
    @vendor_ledger = FactoryGirl.create(:vendor_ledger)
  end

  test 'should return the bill number' do
    assert_not_empty @vendor_ledger.voucher.bill_number
  end
  
  test 'should return the voucher id' do
    assert_not_nil @vendor_ledger.voucher.id
  end

  test 'should update the ledger if bill made' do
    assert_equal 'Bill', @vendor_ledger.voucher_type
    assert_equal 3000, @vendor_ledger.amount
    assert_equal 0, @vendor_ledger.paid
  end

  test 'should update the ledger if payment made' do
    @payment = FactoryGirl.create(:paid_ledger, vendor: @vendor_ledger.vendor)
    @vendor_ledger.reload
    assert_equal 'Payment', @payment.voucher_type
    assert_equal 500, @vendor_ledger.paid
    assert_equal 500, @payment.amount
    assert_equal 500, @payment.paid
    assert_equal @vendor_ledger.vendor, @payment.vendor
  end
end
