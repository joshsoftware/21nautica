class FuelStock < ActiveRecord::Base
  validates_presence_of :quantity, :rate, :date

  before_save :assign_balance

  def assign_balance
    self.balance = quantity
  end

  def self.update_and_get_cost(quantity)
    quantity_to_dispense = quantity
    available_stocks = FuelStock.where("balance > 0").order(:date)
    stock_index = 0
    loop_threshold = FuelStock.count + 10
    cost = 0
    while quantity_to_dispense > 0
      fuel_stock = available_stocks[stock_index]
      if fuel_stock.balance > quantity_to_dispense
        fuel_stock.update_column(:balance, (fuel_stock.balance.to_f - quantity_to_dispense.to_f))
        cost = cost + (quantity_to_dispense.to_f * fuel_stock.rate)
        quantity_to_dispense = 0
      else
        quantity_to_dispense = quantity_to_dispense - fuel_stock.balance
        cost = cost + (fuel_stock.balance * fuel_stock.rate)
        fuel_stock.update_column(:balance, 0)
      end
      stock_index = stock_index + 1
      break if stock_index > loop_threshold
      #above break is applied to avoid to go into infinity loop, in case of code failure
    end
    cost
  end
end
