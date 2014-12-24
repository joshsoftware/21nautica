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
    customer_id = params[:customer_id]
    @payments = Received.where(customer_id: customer_id).order(date_of_payment: :desc)
    @header = Customer.find_by(id: customer_id).try(:name)
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
