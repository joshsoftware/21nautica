class ReceivedController < ApplicationController
  require 'numbers_in_words/duck_punch'
  before_action :set_customers, :set_count, only: %i[new fetch_form_partial]
  def new
    @received = Received.new
  end

  def save_data(paid_params)
    @received = Received.new(paid_params)
    byebug
    if @received.save
      flash[:notice] = "Payment entry saved sucessfully"
      receipt = generate_receipt
      #UserMailer.payment_received_receipt(@received.customer.emails, receipt).deliver()
      # UserMailer.payment_received_receipt(@received.customer, receipt).deliver()
    else
      render 'new'
    end
  end

  def create
    params[:received].each do |param_received|
      print param_received[1]
      save_data(param_received[1])
    end
    redirect_to new_received_path
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

  def fetch_form_partial
    @count = params[:count].present? ? params[:count].to_i + 1 : 0
    respond_to do |format|
      format.js {  }
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
    customer.invoices.order(date: :asc).sent.each do |inv|
      inv.create_ledger(amount: inv.amount, customer: inv.customer, date: inv.date, received: 0)
    end

    # Add all received ledgers
    customer.payments.order(date_of_payment: :asc).each do |payment|
      payment.create_ledger(amount: payment.amount, customer: payment.customer, date: payment.date_of_payment)
    end

    redirect_to customer_ledger_path
  end

  private

  # def paid_params
  #   params.require(:received).permit(:received => %i[customer_id
  #     date_of_payment])
  # end

  def generate_receipt
    date = Date.current.strftime("%y%d%m")
    count = Received.where("created_at > ?", Date.current).count
    @receipt_number = date + count.to_s
    html = render_to_string(:action => 'receipt.html.haml', :layout=> false)
    kit = PDFKit.new(html)
    pdf = kit.to_pdf
    file = kit.to_file("#{Rails.root}/tmp/payment_receipt_#{@receipt_number}.pdf")
  end

  def set_customers
    @customers =  Customer.order(:name).pluck(:name,:id).to_h
  end

  def set_count
    # @count = try(@count).
  end
end
