class ReportsController < ApplicationController
  
  def vendor_invoice
  end

  def customer_invoice
    
  end

  def payments_made
    @vendors = Vendor.order(:name).pluck(:name, :id)
    vendor_id = params[:vendor_id] || @vendors.first[1].to_s
    if !params[:daterange].blank?
      @paids = Paid.where(:date_of_payment => Date.parse(params[:daterange].split("-")[0])..Date.parse(params[:daterange].split("-")[1] ), vendor_id: vendor_id)
    else
      @paids = Paid.where(vendor_id: vendor_id)
    end
    respond_to do |format|
      format.html{}
      format.json { render json: { :data => @paids.order(date_of_payment: :desc).offset(params[:start]).limit(params[:length] || 10).map(&:report_json), "recordsTotal" => @paids.count, "recordsFiltered" => @paids.count } }
    end
  end

  def payments_received
    
  end
end
