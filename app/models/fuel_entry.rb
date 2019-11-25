class FuelEntry < ActiveRecord::Base
  attr_accessor :rate
  belongs_to :truck
  validates_presence_of :date, :quantity
  validate :vehicle_truck_presence

  before_save :check_fuel_balance, :check_fuel_entry_date
  after_save :update_available_n_cost_for_entry

  def vehicle_truck_presence
    if purchased_dispensed == "dispense" && !is_adjustment
      errors.add(:base, "Either truck or office vehicle must be present") if office_vehicle.blank? && truck_id.blank?
    end
    self.errors.present?
  end

  def check_fuel_balance
    if purchased_dispensed != "purchase" && FuelStock.sum(:balance) < quantity
      errors.add(:base, "Not enough fuel in fuel stock")
    end
    !self.errors.present?
  end

  def update_available_n_cost_for_entry
    if purchased_dispensed == "purchase"
      available_balance = FuelStock.sum(:balance).to_f + quantity.to_f
      fuel_cost = quantity * rate.to_f
    elsif purchased_dispensed == "dispense"
      available_balance = FuelStock.sum(:balance).to_f - quantity.to_f
      fuel_cost = FuelStock.update_and_get_cost(quantity)
    end
    update_columns(cost: fuel_cost, available: available_balance)
  end

  def check_fuel_entry_date
    #should not allow fuel entry date is less than last entry date 
    self.errors.add(:base, "Can't create fuel entry previous than last entry") if FuelEntry.count > 0 && self.date < FuelEntry.order(:date).last.date
    !self.errors.present?
  end

end
