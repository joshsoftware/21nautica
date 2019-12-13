# == Schema Information
#
# Table name: bill_items
#
#  id            :integer not_null, primary
#  serial_number :integer
#  bill_id       :integer
#  bill_date     :datetime
#  vendor_id     :integer
#  item_type     :string
#  item_number   :text
#  item_for      :string  default: 'bl'
#  charge_for    :text
#  quantity      :integer
#  rate          :float
#  line_amount   :float
#  activity_id   :integer
#  activity_type :string
#  created_at    :datetime
#  update_at     :datetime

require 'test_helper'

class BillItemTest < ActiveSupport::TestCase
  setup do
    @bill_item = FactoryGirl.create(:bill_item)
  end

  test 'should belongs to bill' do
    assert @bill_item.bill
  end

  test 'should belongs to vendor' do
    assert @bill_item.bill.vendor
  end

  test 'should belongs to import activity' do
    assert @bill_item.activity
    assert_equal @bill_item.activity.class.name, 'Import'
  end

  test 'should validates numericality of rate greater than 0' do
    @bill_item.rate = 0 
    @bill_item.save
    assert @bill_item.errors.messages[:rate].include?('must be greater than 0')
  end

  test 'should assigned bill_date and vendor_id of bill' do
    assert_equal @bill_item.bill.vendor_id, @bill_item.vendor_id
    assert_equal @bill_item.bill.bill_date, @bill_item.bill_date
  end

  test 'should ensure inclusion item_for [bl, container]' do
    assert_includes ['bl', 'container'], @bill_item.item_for
  end

  test 'should ensure inclusion item_type [Import, Export]' do
    assert_includes ['Import', 'Export'], @bill_item.item_type
  end

  test 'should check total bl quantity for Import' do
    @bill_item.quantity = 5
    if ENV['HOSTNAME'] != 'RFS'
      assert_not @bill_item.save
      assert @bill_item.errors.messages[:quantity].include?('Total charged qty exceeds Import BL qty')
    end
  end
end
