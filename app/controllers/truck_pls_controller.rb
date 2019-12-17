class TruckPlsController < ApplicationController
  def index
    month = params[:date].present? ? params[:date].split("-")[0] : Date.today.month
    year = params[:date].present? ? params[:date].split("-")[1] : Date.today.year
    @trucks = []
    Truck.where.not(reg_number: TRUCK_REG_NUMBER).each do |truck|
      income = 0
      amount = 0
      quantity = 0
      Import.joins(:import_items).where("import_items.truck_id=?",truck.id).each do |import|
        quantity = import.quantity
        import.bill_of_lading.invoices.where('extract(month from date)=?',month).where('extract(year from date)=?',year).each do |inv|
          amount += inv.particulars.where(name:"Transport Charges").sum(:subtotal)/quantity
          amount += inv.particulars.where.not(name:"Transport Charges").sum(:subtotal)
        end
        income += amount
      end
      expense = truck.petty_cashes.where('extract(month from date)=?',month).where('extract(year from date)=?',year).sum(:transaction_amount)
      expense += truck.req_sheets.where('extract(month from date)=?',month).where('extract(year from date)=?',year).sum(:value)
      expense += truck.fuel_entries.where('extract(month from date)=?',month).where('extract(year from date)=?',year).sum(:cost)
      expense += truck.try(:insurance_premium_amt_yearly).to_i / 12 if truck.try(:insurance_premium_amt_yearly)
      @trucks << {truck_number: truck.reg_number, income: income, expense: expense.round(2), diff: (income-expense).round(2)}
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
end