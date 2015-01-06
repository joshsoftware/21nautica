# == Schema Information
#
# Table name: import_items
#
#  id               :integer          not null, primary key
#  container_number :string(255)
#  trailer_number   :string(255)
#  tr_code          :string(255)
#  truck_number     :string(255)
#  current_location :string(255)
#  bond_direction   :string(255)
#  bond_number      :string(255)
#  status           :string(255)
#  import_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class ImportItemTest < ActiveSupport::TestCase
  setup do
    @import_item1 = FactoryGirl.create :import_item1
  end

  test "should not assign truck which is not free" do
    @import_item1.truck_number = "TR123"
    @import_item1.save!
    import_item2 = ImportItem.new
    import_item2.truck_number = "TR123"
    assert_not import_item2.save
    assert import_item2.errors.messages[:truck_number].include?(
                        " TR123 is not free !")
  end

  test "NEW invoice if loaded out of port and invoice not already present" do
  end

  test "READY invoice if loaded out of port and truck assigned to rest containers" do
  end

  test "do nothing if loaded out of port but invoice is already ready" do
  end

  test "for multiple containers,READY invoice if state of container changed to :truck_allocated, invoice present
  (at least one container is loaded out of port) and no container is in :under_loading_process state" do
  end

  test "No invoice if, only truck allocated to all containers and no container is ready to load" do
  end

  test "date of Invoice should be the date of Loaded_out_of_Port for the first container" do
  end
  
  test "READY invoice if loaded out of port and invoice not already present and BL has only one container" do
  end
end
