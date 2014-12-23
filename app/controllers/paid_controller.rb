class PaidController < ApplicationController
  def new
    @paid = Paid.new
    @transporters =  Vendor.pluck(:name,:id).to_h
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

  private

  def paid_params
    params.require(:paid).permit(:participants_name, :date_of_payment,
            :amount, :mode_of_payment, :reference, :remarks, :vendor_id)
  end

end
