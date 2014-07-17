class CustomersController < ApplicationController

  def new
    @customer = Customer.new
  end

  def create
    customer = Customer.new(customer_params)
    if customer.save
      flash[:notice] = 'Successfully added new Customer'
    else
      flash[:error] = 'Error while saving customer'
    end
    @customers = Customer.all.to_a
    render 'new'
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :emails)
  end
end
