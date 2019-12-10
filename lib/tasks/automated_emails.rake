namespace :automated_emails do
  desc "Reminder for BL and/or entry number not recieved"
  task bl_entry_number_reminder: :environment do
    p "Sending bl and entry number reminder email #{Date.today}"
    imports = Import.select(:id, :bl_received_at, :entry_number, :estimate_arrival, :customer_id, :bl_number, :bill_of_lading_id).where.not(status: "ready_to_load").where("imports.bl_received_at IS NULL OR imports.entry_number IS NULL").where("imports.estimate_arrival <= ?", (Date.today + 5.days))
    imports.pluck(:customer_id).uniq.each do |customer_id|
      customer = Customer.select(:emails, :id).find(customer_id)
      customer_imports = imports.select {|import| import.customer_id == customer_id}
      UserMailer.bl_entry_number_reminder(customer_imports, customer).deliver
    end
  end

  task container_returned_date_report: :environment do
    p "Sending Container returned date report email #{Date.today}"
    Report::DailyReport.new.container_returned_date_report
    p "Sending Container returned date report email done for #{Date.today}"
  end

  task truck_not_allotted_report: :environment do
    p "Sending truck not allocated containers report email #{Date.today}"
    Report::TruckAllocation.new.create_and_send
    p "Sent truck not allocated containers report email #{Date.today}"
  end

  task purchase_order_status: :environment do
    p "Sending purchase order status report email #{Date.today}"
    Report::PurchaseStatus.new.create_and_send
    p "Sent purchase order status report email #{Date.today}"
  end

  task purchase_order_summary: :environment do
    p "Sending purchase order summary report email #{Date.today}"
    UserMailer.purchase_order_summary.deliver
    p "Sent purchase order summary report email #{Date.today}"
  end

  task new_order_summary: :environment do
    p "Sending new order summary report email #{Date.today}"
    UserMailer.new_order_summary.deliver
    p "Sent new order summary report email #{Date.today}"
  end
end
