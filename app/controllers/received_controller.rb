class ReceivedController < ApplicationController
  def new
    @received = Received.new
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

  private

  def paid_params
    params.require(:received).permit(:participants_name, :date_of_payment,
            :amount, :mode_of_payment, :reference, :remarks)
  end

end
