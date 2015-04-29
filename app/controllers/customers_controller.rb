class CustomersController < ApplicationController

  def new
    @customer = Customer.new
  end

  def create
    customer = Customer.new(customer_params)
    customer.save ? @customers = Customer.order(:name).to_a : @errors = customer.errors.messages.values.flatten
    render 'new'
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :emails)
  end

end
