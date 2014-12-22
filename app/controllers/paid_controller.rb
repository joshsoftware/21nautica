class PaidController < ApplicationController
  def new
    @paid = Paid.new
  end

  def create
    @paid = Paid.new(paid_params)
    if @paid.save
      flash[:notice] = "Payment entry saved sucessfully"
      redirect_to :root
    else
      render 'new'
    end
  end

  def index
    participants_name = params[:participants_name]
    @payments = Paid.where(participants_name: participants_name).order(date_of_payment: :desc)
    @header = participants_name
    respond_to do |format|
      format.js {}
      format.html {redirect_to :root}
    end
  end

  private

  def paid_params
    params.require(:paid).permit(:participants_name, :date_of_payment,
            :amount, :mode_of_payment, :reference, :remarks)
  end

end
