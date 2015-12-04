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
      #UserMailer.payment_received_receipt(@received.customer.emails, receipt).deliver()
      UserMailer.payment_received_receipt(@received.customer, receipt).deliver()
      redirect_to new_received_path
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

  def delete_ledger
    received = Received.find(params[:id])
    customer_id = received.customer_id
    received.destroy

    redirect_to readjust_customer_path(customer_id)
  end

  def readjust
    customer = Customer.find(params[:id])

    # Remove all legders for this customer
    Ledger.where(customer: customer).destroy_all
    # Add all invoice ledgers first
    customer.invoices.sent.each do |inv|
      inv.create_ledger(amount: inv.amount, customer: inv.customer, date: inv.date, received: 0)
      inv.update_ledger
    end

    # Add all received ledgers
    customer.payments.each do |payment|
      payment.create_ledger(amount: payment.amount, customer: payment.customer, date: payment.date_of_payment)
      payment.update_ledger
    end

    redirect_to new_received_path
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
