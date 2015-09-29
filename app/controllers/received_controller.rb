class ReceivedController < ApplicationController
  require 'numbers_in_words/duck_punch'
  def new
    @received = Received.new
    @customers =  Customer.order(:name).pluck(:name,:id).to_h
  end

  def create
    @received = Received.new(paid_params)
    if @received.save
      flash[:notice] = "Payment entry saved sucessfully"
      receipt = generate_receipt
      UserMailer.payment_received_receipt(@received.customer.emails, receipt).deliver()
      redirect_to :root
    else
      render 'new'
    end
  end

  def outstanding
    data = Report::RunningAccount.outstanding('customer')
    send_data data, filename: "#{Date.today}-outstanding.csv", type: "text/csv"
  end

  def show
    c = Customer.find(params[:id])
    data = Report::RunningAccount.create(c, 'customer')
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

  def generate_receipt
    date = Date.current.strftime("%y%d%m")
    count = Received.where("created_at > ?", Date.current).count
    @receipt_number = date + count.to_s
    html = render_to_string(:action => 'receipt.html.haml', :layout=> false)
    kit = PDFKit.new(html)
    pdf = kit.to_pdf
    file = kit.to_file("#{Rails.root}/tmp/payment_receipt_#{@receipt_number}.pdf")
  end

end
