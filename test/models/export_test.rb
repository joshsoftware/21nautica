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
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class ExportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
