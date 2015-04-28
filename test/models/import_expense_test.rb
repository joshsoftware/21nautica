require 'test_helper'

class ImportExpenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @import_item1 = FactoryGirl.create :import_item1
    @import = FactoryGirl.create :import
    @transporter = FactoryGirl.create :vendor
    @import_expense1 = FactoryGirl.create :import_expense1
    @import_expense2 = FactoryGirl.create :import_expense2
    @import_expense3 = FactoryGirl.create :import_expense3
    @import_expense4 = FactoryGirl.create :import_expense4
    @import_expense5 = FactoryGirl.create :import_expense5
    @import_expense1.import_item = @import_item1
    @import_expense5.import_item = @import_item1
    @import_item1.transporter = @transporter
    @import_item1.import = @import
    %W(Panafrica EACL Agility Paul Inland\ Logistics).each do |agent_name|
      Vendor.create(name: agent_name, vendor_type: "clearing_agent")
    end
  end

  test "returns collection for name field depending on category" do
    assert_equal ['Mansons'], @import_expense1.get_collection
    #assert_equal ["Mansons", "Farsham", "Panafrica", "Crown",
    #              "Panafrica Logistics", "Midland Hauliers", 
    #              "Blue Jay"], @import_expense2.get_collection
    assert_equal ['Maina','Multiple'], @import_expense3.get_collection
    assert_equal ["Agility", "EACL", "Inland Logistics", "Panafrica", "Paul"], @import_expense4.get_collection
    assert_equal ["Evergreen"], @import_expense5.get_collection
  end


end
