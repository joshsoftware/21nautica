#
# == Schema Information
# Table name: customers
#
#  id            :integer      not null, primary key
#  bill_number   :text
#  bill_date     :datetime
#  vendor_id     :integer
#  value         :float
#  remark        :text
#  created_by    :integer
#  created_on    :datetime
#  approved_by   :integer
require 'test_helper'

class BillTest < ActiveSupport::TestCase
  setup do
    @bill = FactoryGirl.create :bill
  end

  test "check if bill items present and valid" do
    assert @bill.bill_items.map(&:valid?)
  end

  test 'it should create vendor ledger' do
   assert @bill.vendor_ledger 
  end

  test 'it should create vendor ledger of voucher type Bill' do
    assert_equal 'Bill', @bill.vendor_ledger.voucher_type
  end

  test 'it should set the vendor ledger value equals to bill value ' do
    assert_equal @bill.value, @bill.vendor_ledger.amount
  end

  test 'it should set the vendor ledger currency equals to bill currency ' do
    assert_equal @bill.currency, @bill.vendor_ledger.currency
  end

  test 'it should set the vendor ledger date equals to bill date ' do
    assert_equal @bill.bill_date, @bill.vendor_ledger.date
  end

  test 'it should set the vendor ledger default paid to 0 ' do
    assert_equal 0, @bill.vendor_ledger.paid
  end
end
