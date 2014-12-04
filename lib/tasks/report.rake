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
    Expense::Dump.new.generate
    UserMailer.mail_expense_report("Dump").deliver
  end

  desc "TODO"
  task expense_delta: :environment do
    Expense::Delta.generate_report
    UserMailer.mail_expense_report("Delta").deliver
  end


end
