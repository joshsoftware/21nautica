# frozen_string_literal: true

# == Schema Information
#
# Table name: imports
#
#  id               :integer          not null, primary key
#  equipment        :string(255)
#  quantity         :integer
#  from             :string(255)
#  to               :string(255)
#  bl_number        :string(255)
#  estimate_arrival :date
#  description      :string(255)
#  rate             :string(255)
#  status           :string(255)
#  out_of_port_date :date
#  customer_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require "test_helper"

class ImportTest < ActiveSupport::TestCase
  setup do
    @import = FactoryGirl.create :import
  end

  test "Bl number must be unique" do
    import = Import.new(bl_number: @import.bl_number)
    assert_not import.save
  end

  test "should set the clearing agent" do
    clearing_agent = FactoryGirl.create(:vendor)
    @import.clearing_agent_id = clearing_agent.id
    assert_equal @import.clearing_agent, clearing_agent.name
  end

  test "must assigned file ref number before ready to load" do
    @import.status = "copy_documents_received"
    @import.original_documents_received!
    @import.container_discharged!
    assert_raises(AASM::InvalidTransition) do
      @import.ready_to_load!
    end
  end

  test "Shipping dates must be chronologically(in order)(charges_paid_at)" do
    #order is bl_received_at, charges_received_at, charges_paid_at, do_received_at
    @import.bl_received_at = Date.today
    @import.charges_paid_at = Date.today
    @import.save
    @import.reload
    assert_equal @import.charges_paid_at, nil
  end

  test "Shipping dates must be chronologically(in order)(do_recieved_at)" do
    #order is bl_received_at, charges_received_at, charges_paid_at, do_received_at
    @import.bl_received_at = Date.today
    @import.charges_received_at = Date.today
    @import.do_received_at = Date.today
    @import.save
    @import.reload
    assert_equal @import.do_received_at, nil
  end

  test "save entry type according to entry number" do
    @import.entry_number = "S12345"
    @import.save
    @import.reload
    assert_equal @import.entry_type, "wt8"
  end

  test "Test the method #shipping_checked? - should return false if dates not present" do
    @import.bl_received_at = nil
    @import.save
    @import.reload
    assert_equal @import.shipping_checked?, false
  end

  test "Test the method #shipping_checked? - should return true if dates present" do
    @import.bl_received_at = Date.today
    @import.charges_received_at = Date.today
    @import.charges_paid_at = Date.today
    @import.do_received_at = Date.today
    @import.save
    @import.reload
    assert_equal @import.shipping_checked?, true
  end

  test "Set bl received date when bl received type is original_telex" do
    import = Import.new(to: 'location 2', from: 'location 1', estimate_arrival: '10-10-2014',
     equipment: '20GP', quantity: 3, rate_agreed: 3000, weight: 30,
     bl_received_type: "original_telex", work_order_number: 1234, bl_number: "test#{DateTime.now.to_i}")
    import.save
    import.reload
    assert_equal import.bl_received_at, Date.today
  end

  test "Check custom entry generated function - true" do
    @import.entry_number = "CSINJH"
    @import.save
    @import.reload
    assert_equal @import.custom_entry_generated?, true
  end
end
