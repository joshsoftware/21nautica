namespace :report do
  desc "TODO"
  task import_report: :environment do
	CustomersController.new.daily_report_import
  end

  desc "TODO"
  task export_report: :environment do
	CustomersController.new.daily_report_export
  end

end
