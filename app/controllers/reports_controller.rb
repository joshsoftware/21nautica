class ReportsController < ApplicationController
  
  def vendor_invoice
  end

  def customer_invoice
    
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
    
  end
end
