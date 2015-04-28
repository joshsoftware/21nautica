class ReceivedController < ApplicationController
  def new
    @received = Received.new
    @customers =  Customer.order(:name).pluck(:name,:id).to_h
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

  def outstanding
    data = Report::RunningAccount.outstanding
    send_data data, filename: "#{Date.today}-outstanding.csv", type: "text/csv"
  end

  def show
    c = Customer.find(params[:id])
    data = Report::RunningAccount.create(c)
    send_data data, filename: "#{Date.today}-#{c.name.gsub(' ', '_')}.csv", type: "text/csv"
  end

  def index
    customer = Customer.where(id: params[:customer_id]).first
    @payments = customer.ledgers.order(date: :desc).to_json
    @header = customer
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
