module ApplicationHelper
  def get_date_range(payment_type)
  	current_date = Date.current
  	end_date = Date.current.to_s
  	start_date = payment_type.eql?("paid") ? Paid.minimum(:date_of_payment).to_s : 
  	  (Date.current - 2.years).to_s
  	days_select_box_data = [["All Time", start_date + "," + end_date],
  	  ["Last 30 days", (current_date - 30.days).to_s + "," + end_date], 
  	  ["30 - 60 days",  (current_date - 60.days).to_s + "," + (current_date - 30.days).to_s], 
  	  ["60 - 90 days", (current_date - 90.days).to_s + "," + (current_date - 60.days).to_s ],
  	  ["90 - 120 days", (current_date - 120.days).to_s + "," + (current_date - 90.days).to_s ],
  	  ["More than 120 days", start_date + "," + (current_date - 120.days).to_s]]
  end

  def get_shipping_line_vendors
    vendor = Vendor.shipping_lines
    vendor.map { | vendor | [vendor.name, vendor.id] }
  end

  def reallocate_truck_numbers
    if @import_item.truck_id.present?
      trucks = Truck.free.pluck(:reg_number, :id)
      trucks << [@import_item.truck.reg_number, @import_item.truck_id]
    else
      Truck.free.pluck(:reg_number, :id)
    end
  end

end
