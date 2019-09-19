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

class RemarkTest < ActiveSupport::TestCase

  test "if remark type valid" do
    remark = Remark.new(category: "internal", date: Date.today, desc: "testing", remarkable: (FactoryGirl.create :import))
    assert remark.valid?
  end
end
