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
  	  ["More than 90 days", start_date + "," + (current_date - 90.days).to_s]]
  end
end
