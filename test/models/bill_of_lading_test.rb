require 'test_helper'

class BillOfLadingTest < ActiveSupport::TestCase
  setup do
    @shipping_line = FactoryGirl.create :vendor, name: 'CGM Maersk', vendor_type: 'shipping_line'
  	@movement = FactoryGirl.create :movement
    @export = FactoryGirl.create :export
    @export_item = FactoryGirl.create :export_item
  	@bill_of_lading = FactoryGirl.create :bill_of_lading, bl_number: 'BL_NUMBER1'
    @bill_of_lading.import.shipping_line_id = @shipping_line.id
  	@movement.bill_of_lading = @bill_of_lading
  	@export_item.export = @export
  	@export_item.movement = @movement
  	@movement.save!
  end

  test "should return true if bill_of_lading is of export type" do
    assert_equal false, @bill_of_lading.is_export_bl?
  end

  test "should return shipping_line depending on associated object" do
    assert_equal "CGM Maersk", @bill_of_lading.shipping_line
  end

end
