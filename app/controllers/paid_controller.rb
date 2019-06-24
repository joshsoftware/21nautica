class PaidController < ApplicationController
  def new
    @paid = Paid.new
  end

  def create
    @paid = Paid.new(paid_params)
    if @paid.save
      flash[:notice] = "Payment entry saved sucessfully"
      redirect_to new_paid_path
    else
      render 'new'
    end
  end

  # Deleting the payments and readjust the vendor ledger 
  #
  def delete_ledger
    paid = Paid.find(params[:id])
    vendor_id = paid.vendor_id
    paid.destroy

    redirect_to readjust_path(vendor_id)
  end

  def readjust
    vendor = Vendor.find(params[:id])
    
    VendorLedger.where(vendor_id: vendor).destroy_all


    vendor.debit_notes.each do |debit_note|
      debit_note.create_vendor_ledger(vendor: debit_note.vendor, date: debit_note.bill.bill_date, amount: debit_note.amount, 
                                      currency: debit_note.bill.currency)
    end

    vendor.payments.order(date_of_payment: :asc).each do |payment|
      payment.create_vendor_ledger(amount: payment.amount, vendor: payment.vendor, date: payment.date_of_payment, currency: payment.currency)
    end

    vendor.bills.order(bill_date: :asc).each do |bill|
      bill.create_vendor_ledger(amount: bill.value, vendor_id: bill.vendor_id, date: bill.bill_date, currency: bill.try(:currency))
    end

    redirect_to new_paid_path
  end

  def outstanding
    data = Report::RunningAccount.outstanding('vendor')
    send_data data, filename: "#{Date.today}-outstanding.csv", type: "text/csv"
  end

  def show
    v = Vendor.find(params[:id])
    data = Report::RunningAccount.create(v, 'vendor')
    send_data data, filename: "#{Date.today}-#{v.name.gsub(' ', '_')}.csv", type: "text/csv"
  end

  def index
    vendor = Vendor.where(id: params[:vendor_id]).first
    @payments = vendor.vendor_ledgers.includes(:voucher).order(date: :desc, id: :desc).to_json
    @header = vendor
    respond_to do |format|
      format.js {}
      format.html {redirect_to :root}
    end
  end

  private

  def paid_params
    params.require(:paid).permit(:date_of_payment, :amount, :mode_of_payment, 
      :reference, :remarks, :vendor_id, :currency)
  end

end
