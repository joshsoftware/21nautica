require 'test_helper'

class VendorTest < ActiveSupport::TestCase

  setup do
    @vendor = FactoryGirl.create :vendor
  end
  
  test 'should not create vendor with Invalid vendor type' do
    vendor = Vendor.new
    vendor.name = 'Paritosh'
    vendor.vendor_type = 'XYZ, ABCD'
    assert_not vendor.save
  end

  test 'should not create vendor without name' do
    vendor = Vendor.new
    vendor.vendor_type = 'icd'
    assert_not vendor.save
    assert vendor.errors.messages[:name].include?("can't be blank")
  end

end
