# == Schema Information
#
# Table name: exports
#
#  id                   :integer          not null, primary key
#  equipment            :string(255)
#  quantity             :string(255)
#  export_type          :string(255)
#  shipping_line        :string(255)
#  placed               :integer
#  release_order_number :string(255)
#  customer_id          :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class ExportTest < ActiveSupport::TestCase
  test "quantity must be specified for creation of export" do
    export = Export.new
    assert_not export.save
    assert export.errors.messages[:quantity].include?(
                  "can't be blank")
  end

  test  "R/O number must be unique" do
    export1 = FactoryGirl.create :export
    export2 = Export.new
    export2.quantity = 2
    export2.release_order_number = '12345678'
    assert_not export2.save
    assert export2.errors.messages[:release_order_number].include?(
                    "Duplicate R/O Number not allowed!")
  end

  test "should get customer name" do
    export1 = FactoryGirl.create :export
    customer = FactoryGirl.create :customer
    export1.customer = customer
    assert_equal export1.customer_name, 'Cust1'
  end

end
