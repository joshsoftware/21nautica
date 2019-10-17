namespace :automated_emails do
  desc "Reminder for BL and/or entry number not recieved"
  task bl_entry_number_reminder: :environment do
    p "Sending bl and entry number reminder email"
    customers = Customer.joins(:imports).where.not(:imports => {status: "ready_to_load"}).where("(imports.bl_received_at IS NULL OR imports.entry_number IS NULL) AND (imports.estimate_arrival BETWEEN ? AND ?)", Date.today, (Date.today + 5.days)).uniq
    customers.each do |customer|
     UserMailer.bl_entry_number_reminder(customer).deliver
    end
  end
end
