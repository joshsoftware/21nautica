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

end
