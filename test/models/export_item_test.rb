# == Schema Information
#
# Table name: export_items
#
#  id                :integer          not null, primary key
#  container         :string(255)
#  location          :string(255)
#  weight            :string(255)
#  export_id         :integer
#  movement_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  date_of_placement :date
#

require 'test_helper'

class ExportItemTest < ActiveSupport::TestCase
  setup do
    @export_item = FactoryGirl.create :export_item
    @movement = FactoryGirl.create :movement
    @export_item.movement = @movement
  end

  test "date of placement cannot be in future" do
    @export_item.date_of_placement = Date.tomorrow
    assert_not @export_item.save
    assert @export_item.errors.messages[:date_of_placement].include?(
                        "Must be not be in the future")
  end

  test "should assign container if its free(handed over)" do
    @movement.status = "container_handed_over_to_KPA"
    @movement.save!
    export_item2 = ExportItem.new
    export_item2.container = 'A1'
    export_item2.date_of_placement = Date.today
    export_item2.movement_id = @movement.id
    assert export_item2.save
  end

  test "should not assign container which is not free" do
    export_item3 = ExportItem.new
    export_item3.container = '1'
    assert_not export_item3.save
    assert export_item3.errors.messages[:container].include?(
                          "1 is not free !")
  end

  test "json should contain date since placement field" do
    assert_not @export_item.attributes.has_key?('date_since_placement')
    assert @export_item.as_json.has_key?('date_since_placement')
  end
end
