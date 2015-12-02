# == Schema Information
#
# Table name: movements
#
#  id                   :integer          not null, primary key
#  booking_number       :string(255)
#  truck_number         :string(255)
#  vessel_targeted      :string(255)
#  point_of_destination :string(255)
#  point_of_loading     :string(255)
#  estimate_delivery    :date
#  movement_type        :string(255)
#  shipping_seal        :string(255)
#  custom_seal          :string(255)
#  current_location     :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class MovementTest < ActiveSupport::TestCase
  setup do
    @movement1 = FactoryGirl.create(:movement, :truck_number => 'c1')
    @bill_of_lading = FactoryGirl.create(:bill_of_lading)
    @export_item = FactoryGirl.create :export_item
    @export = FactoryGirl.create :export
    @customer = FactoryGirl.create :customer
    @export_item.export = @export
    @export_item.movement = @movement1
    @export.customer = @customer
  end

  test "should not assign truck which is not free" do
    movement2 = Movement.new
    movement2.truck_number = "c1"
    assert_not movement2.save
    assert movement2.errors.messages[:truck_number].include?(
                      " c1 is not free !")
  end

  test "should not save movement without truck number" do
    movement = Movement.new
    assert_not movement.save
    assert movement.errors.messages[:truck_number].include?(
                    "can't be blank")
  end

  test "json should include container field" do
    assert_not @movement1.attributes.has_key?('container_number')
    assert @movement1.as_json.has_key?('container_number')
  end

  test 'should not move status to container_handed_over_to_KPA' do
    @movement1.arrived_malaba_border
    @movement1.crossed_malaba_border
    @movement1.order_released
    @movement1.arrived_port

    assert_raises(AASM::InvalidTransition) do
      @movement1.document_handed
    end
  end

  test 'should not create invoice if Bl_number is not present' do
    @movement1.bill_of_lading = @bill_of_lading
    @movement1.bl_number = @bill_of_lading.bl_number

    @movement1.arrived_malaba_border
    @movement1.crossed_malaba_border
    @movement1.order_released
    @movement1.arrived_port

    assert true, @movement1.bill_of_lading.invoices.blank?
  end

  test 'should create invoice for TBL Export type' do
    @movement1.movement_type = 'TBL'
    @movement1.bill_of_lading = @bill_of_lading
    @movement1.bl_number = @bill_of_lading.bl_number
    @movement1.save


    @movement1.arrived_malaba_border
    @movement1.crossed_malaba_border
    @movement1.order_released
    @movement1.arrived_port
    @movement1.document_handed

    assert true, @movement1.bill_of_lading.invoices.present?
  end

end
