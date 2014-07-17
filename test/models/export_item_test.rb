# == Schema Information
#
# Table name: export_items
#
#  id          :integer          not null, primary key
#  container   :string(255)
#  location    :string(255)
#  weight      :string(255)
#  export_id   :integer
#  movement_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ExportItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
