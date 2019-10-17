namespace :automated_emails do
  desc "Reminder for BL and/or entry number not recieved"
  task bl_entry_number_reminder: :environment do
    p "Sending bl and entry number reminder email"
    imports = Import.select(:id, :bl_received_at, :entry_number, :estimate_arrival, :customer_id, :bl_number).where.not(status: "ready_to_load").where("imports.bl_received_at IS NULL OR imports.entry_number IS NULL").where("imports.estimate_arrival <= ?", (Date.today + 5.days))
    imports.pluck(:customer_id).uniq.each do |customer_id|
      customer = Customer.select(:emails, :id).find(customer_id)
      customer_imports = imports.select {|import| import.customer_id == customer_id}
      UserMailer.bl_entry_number_reminder(customer_imports, customer).deliver
    end
  end
end
