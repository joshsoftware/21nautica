namespace :report do
  desc "TODO"
  task import_report: :environment do
    if !Time.now.sunday?
     Report::DailyReport.new.daily_report_import
    end
  end

  desc "TODO"
  task export_report: :environment do
    if !Time.now.sunday?
     Report::DailyReport.new.daily_report_export
    end
  end

  desc "TODO"
  task expense_dump: :environment do
    Expense::Dump.generate_report
    UserMailer.mail_expense_report("Dump").deliver
  end

  desc "TODO"
  task expense_delta: :environment do
    Expense::Delta.generate_report
    UserMailer.mail_expense_report("Delta").deliver
  end

  desc "Reminder for BL and/or entry number not recieved"
  task bl_entry_number_reminder: :environment do
    customers = Customer.includes(:imports).where.not(:imports => {status: "ready_to_load"}).where("imports.bl_received_at IS NULL OR imports.entry_number IS NULL").uniq
    customers.each do |customer|
     UserMailer.bl_entry_number_reminder(customer).deliver
    end
  end
end
