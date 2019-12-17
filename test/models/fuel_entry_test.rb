require 'test_helper'

class FuelEntryTest < ActiveSupport::TestCase
  test "quantity should be present" do
    entry = FuelEntry.new()
    entry.save
    assert entry.errors.full_messages.include?("Date can't be blank")
  end

  test "date should be present" do
    entry = FuelEntry.new()
    entry.save
    assert entry.errors.full_messages.include?("Quantity can't be blank")
  end

  test "give error message id if Vehicle or truck is not present not in adjustment entry" do
    FuelStock.create(rate: 100, quantity: 100, balance: 100, date: Date.today)
    entry = FuelEntry.new(date: Date.today, quantity: 2, purchased_dispensed: "dispense")
    entry.save
    assert entry.errors.full_messages.include?("Either truck or office vehicle must be present")
  end

  test "#check_fuel_entry_date" do
    FuelStock.create(rate: 100, quantity: 100, balance: 100, date: Date.today)
    entry1 = FuelEntry.new(date: Date.today - 2.days, quantity: 2, 
                          purchased_dispensed: "dispense",
                          truck_id: 1)
    entry1.save
    entry2 = FuelEntry.new(date: Date.today - 3.days, quantity: 2, 
                          purchased_dispensed: "dispense",
                          truck_id: 1)
    entry2.save
    assert entry2.errors.full_messages.include?("Can't create fuel entry previous than last entry")
  end
end
