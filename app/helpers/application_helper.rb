module ApplicationHelper
  def get_date_range(payment_type)
  	current_date = Date.current
  	end_date = Date.current.to_s
  	start_date = payment_type.eql?("paid") ? Paid.minimum(:date_of_payment).to_s :
      (Date.current - 2.years).to_s
    [start_date + "," + end_date]
  end

  def get_shipping_line_vendors
    vendor = Vendor.shipping_lines
    vendor.map { | vendor | [vendor.name, vendor.id] }
  end

  def reallocate_truck_numbers
    allotted_not_coloaded = ImportItem.where(:status => [:under_loading_process, :truck_allocated, :ready_to_load], is_co_loaded: false)

    third_party_allotted_trucks = allotted_not_coloaded.where.not(truck_number: nil).order(:truck_number).map {|item| [item.truck_number, item.truck_number]}

    alloted = Truck.joins(:import_items).where(import_items: {id: allotted_not_coloaded.pluck(:id)}).active.pluck(:reg_number, :id).uniq

    free_trucks = Truck.free.order(:reg_number).active.pluck(:reg_number, :id).uniq {|number| number[0]}
    if @import_item.truck_id.present? && @import_item.truck_id != 0
      free_trucks << [@import_item.truck.reg_number, @import_item.truck_id] unless @import_item.is_co_loaded
      alloted << [@import_item.truck.reg_number, @import_item.truck_id] if @import_item.is_co_loaded
    end

    next_truck_ids = ImportItem.pluck(:next_truck_id).uniq
    available_next = Truck.joins(:import_items).where(import_items: {id: allotted_not_coloaded.pluck(:id)}).active.where.not(id: next_truck_ids)
    available_next = available_next.pluck(:reg_number, :id).uniq

    if @import_item.truck_id == 0
      third_party_allotted_trucks << [@import_item.truck_number, @import_item.truck_number]
    end
    third_party_truck = ["3rd Party Truck", 0]
    {
      free: free_trucks.prepend(third_party_truck).sort_by{|t| t[0]},
      alloted: alloted.prepend(third_party_truck).sort_by{|t| t[0]},
      third_party_allotted_trucks: third_party_allotted_trucks.sort_by{|t| t[0]},
      available_next: available_next.sort_by{|t| t[0]}
    }
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
  def date_filter_parameters(payment_type)
    current_date = Date.current
  	end_date = Date.current
  	start_date = payment_type.eql?("paid") ? Paid.minimum(:date_of_payment) :
      (Date.current - 2.years)
    start_date.strftime("%Y-%m-%d") + "," + end_date.strftime("%Y-%m-%d")
  end
end
