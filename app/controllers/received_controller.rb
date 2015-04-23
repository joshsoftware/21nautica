class ReceivedController < ApplicationController
  def new
    @received = Received.new
    @customers =  Customer.pluck(:name,:id).to_h
  end

  def create
    @received = Received.new(paid_params)
    if @received.save
      flash[:notice] = "Payment entry saved sucessfully"
      redirect_to :root
    else
      render 'new'
    end
  end

  def index
    customer = Customer.where(id: params[:customer_id]).first
    @payments = customer.ledgers.order(date: :desc).to_json
    @header = customer.name
    respond_to do |format|
      format.js {}
      format.html {redirect_to :root}
    end
  end

  private

  def paid_params
    params.require(:received).permit(:date_of_payment, :amount, 
      :mode_of_payment, :reference, :remarks, :customer_id)
  end

end
