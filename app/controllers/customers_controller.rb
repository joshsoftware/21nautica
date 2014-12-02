class CustomersController < ApplicationController

  def new
    @customer = Customer.new
  end

  def create
    customer = Customer.new(customer_params)
    customer.save
    @customers = Customer.all.to_a
    render 'new'
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :emails)
  end

  def daily_report_params
    params.permit(:name)
  end

end
