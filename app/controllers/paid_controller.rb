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

  def index
    vendor = Vendor.where(id: params[:vendor_id]).first
    @payments = vendor.payments.order(date_of_payment: :desc)
    @header = vendor.name
    respond_to do |format|
      format.js {}
      format.html {redirect_to :root}
    end
  end

  private

  def paid_params
    params.require(:paid).permit(:date_of_payment, :amount, :mode_of_payment, 
      :reference, :remarks, :vendor_id)
  end

end
