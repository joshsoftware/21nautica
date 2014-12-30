module ApplicationHelper
  def get_date_range
  	current_date = Date.current
  	end_date = Date.current.to_s
  	days_select_box_data = [["All Time", Paid.minimum(:date_of_payment).to_s + "*" + end_date],
  	  ["Last 30 days", (current_date - 30.days).to_s + "*" + end_date], 
  	  ["Last 60 days",  (current_date - 60.days).to_s + "*" + end_date], 
  	  ["Last 90 days", (current_date - 90.days).to_s + "*" + end_date]]
  end
end
