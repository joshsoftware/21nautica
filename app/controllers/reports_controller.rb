class ReportsController < ApplicationController
  
  def vendor_invoices
    @vendors = Vendor.order(:name).pluck(:name, :id)
    vendor_id = params[:vendor_id]
    @vendor_invoices = (params[:vendor_id].present? && params[:vendor_id] != 'all') ? Bill.where(vendor_id: vendor_id) : Bill.all
    if !params[:daterange].blank?
      @vendor_invoices = @vendor_invoices.where(:bill_date => Date.parse(params[:daterange].split("-")[0])..Date.parse(params[:daterange].split("-")[1] ))
    end
    respond_to do |format|
      format.html{}
      format.json { render json: { :data => @vendor_invoices.order(bill_date: :desc).offset(params[:start]).limit(params[:length] || 10), "recordsTotal" => @vendor_invoices.count, "recordsFiltered" => @vendor_invoices.count } }
    end
  end

  def customer_invoices
    @customers = Customer.order(:name).pluck(:name, :id)
    customer_id = params[:customer_id]
    @customer_invoices = (params[:customer_id].present? && params[:customer_id] != 'all') ? Invoice.where(invoiceable_type: 'BillOfLading', customer_id: customer_id) : Invoice.where(invoiceable_type: 'BillOfLading')
    if !params[:daterange].blank?
      @customer_invoices = @customer_invoices.where(:date => Date.parse(params[:daterange].split("-")[0])..Date.parse(params[:daterange].split("-")[1] ))
    end
    respond_to do |format|
      format.html{}
      format.json { render json: { :data => @customer_invoices.order(date: :desc).offset(params[:start]).limit(params[:length] || 10), "recordsTotal" => @customer_invoices.count, "recordsFiltered" => @customer_invoices.count } }
    end
  end

  def payments_made
    @vendors = Vendor.order(:name).pluck(:name, :id)
    vendor_id = params[:vendor_id]
    @paids = (params[:vendor_id].present? && params[:vendor_id] != 'all') ? Paid.where(vendor_id: vendor_id) : Paid.all
    if !params[:daterange].blank?
      @paids = @paids.where(:date_of_payment => Date.parse(params[:daterange].split("-")[0])..Date.parse(params[:daterange].split("-")[1] ))
    end
    respond_to do |format|
      format.html{}
      format.json { render json: { :data => @paids.order(date_of_payment: :desc).offset(params[:start]).limit(params[:length] || 10).map(&:report_json), "recordsTotal" => @paids.count, "recordsFiltered" => @paids.count } }
    end
  end

  def payments_received
    @customers = Customer.order(:name).pluck(:name, :id)
    customer_id = params[:customer_id]
    @receiveds = (params[:customer_id].present? && params[:customer_id] != 'all') ? Received.where(customer_id: customer_id) : Received.all
    if !params[:daterange].blank?
      @receiveds = @receiveds.where(:date_of_payment => Date.parse(params[:daterange].split("-")[0])..Date.parse(params[:daterange].split("-")[1] ))
    end
    respond_to do |format|
      format.html{}
      format.json { render json: { :data => @receiveds.order(date_of_payment: :desc).offset(params[:start]).limit(params[:length] || 10).map(&:report_json), "recordsTotal" => @receiveds.count, "recordsFiltered" => @receiveds.count } }
    end
  end
end
