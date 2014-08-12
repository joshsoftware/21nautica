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

  def daily_report
    customer = Customer.find_by_name(daily_report_params[:name])
    UserMailer.mail_report(customer).deliver
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :emails)
  end

  def daily_report_params
    params.permit(:name)
  end

end
