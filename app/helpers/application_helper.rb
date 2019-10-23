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
    import_items = ImportItem.where(:status => [:under_loading_process, :truck_allocated, :ready_to_load], is_co_loaded: false)
    alloted = Truck.where(id: import_items.pluck(:truck_id).uniq!).pluck(:reg_number).uniq
    alloted.concat(import_items.pluck(:truck_number)).uniq!
    if @import_item.truck_id.present?
      trucks = Truck.free.order(:reg_number).pluck(:reg_number, :id).uniq {|number| number[0]}
      trucks << [@import_item.truck.reg_number, @import_item.truck_id]
    else
      trucks = Truck.free.order(:reg_number).pluck(:reg_number, :id).uniq {|number| number[0]}
    end
    {free: trucks, alloted: alloted}
  end

  def shipping_date_divs(import)
    shortForms = ["OBL", "C/R", "C/P", "DO", "P/L"]
    date_divs = ""
    [:bl_received_at, :charges_received_at, :charges_paid_at, :do_received_at].each_with_index do |date, index|
      if import.send(date).present?
        date_divs += "<div class='date obl'>#{shortForms[index]}: #{import.send(date).to_date.to_formatted_s}</div>"
      end
    end
    date_divs
  end

  def custom_date_divs(import)
    shortForms = ["RN", "EN", "ET"]
    field_divs = ""
    [:rotation_number, :entry_number, :entry_type].each_with_index do |field, index|
      if import.send(field).present?
        field_divs += "<div class='date obl'>#{shortForms[index]}: #{import.send(field).to_s.upcase}</div>"
      end
    end
    field_divs
  end
end
