module Report
  class DailyReport
    def daily_report_export
      customers = []
      movements = Movement.where.not(status: "container_handed_over_to_KPA")
      movements.each do |movement|
        export = Export.find_by id: movement.export_item.export_id
        customers.push(export.customer)
      end
      customers = customers.uniq
      path = "#{Rails.root}/tmp/daily_report.log"

      f = File.new(path, "w+")
      f.puts("********* Sending export report *************")
      f.puts("Processing Started #{Time.now.to_s}")

      customers.each do |customer|
        begin
          f.puts("Processing - #{customer.name}")

          daily_report = Report::Daily.new
          daily_report.create(customer)

          UserMailer.mail_report(customer, 'export').deliver

          #******** creating Report through workers*********************
          #DailyReportWorker.perform_async(customer.id, 'export')
          f.puts("Completed - #{customer.name}")

        rescue Exception => e
          UserMailer.error_mail_report(customer, e).deliver
        end
      end
      f.puts("Processing End at #{Time.now.to_s}")
      f.close

      UserMailer.mail_report_status('export').deliver
    end

    def daily_report_import(customer_id = nil)
      customers = []
      import_items = ImportItem.where.not(status: "delivered").select(:import_id).uniq
      import_items.each do |item|
        import = Import.find(item.import_id)
        if customer_id == nil or import.customer_id == customer_id 
          customers.push(import.customer)
        end
      end
      
      customers = customers.uniq
      path = "#{Rails.root}/tmp/daily_report.log"

      f = File.new(path, "w")
      f.puts("********* Sending import report *************")
      f.puts("Processing Started #{Time.now.to_s}")
      f.puts('Customer List')
      customers.each do |customer|
        f.puts(customer.name)
      end
      f.close

      customers.each do |customer|
        begin
          f1 = File.open(path, 'a+')
          f1.puts("Processing - #{customer.name}")
          f1.close

          p "************ Processing Customer #{customer.name} **********"
          daily_report = Report::DailyImport.new
          daily_report.create(customer)

          UserMailer.mail_report(customer, 'import').deliver
          #******** creating Report through workers*********************
          #DailyReportWorker.perform_async(customer.id, 'import')
        rescue Exception => e
          p "************ Error occured for Customer #{customer.name} **********"
          UserMailer.error_mail_report(customer, e).deliver
        end
      end
      append_mode_file = File.open(path, 'a+')
      append_mode_file.puts("Processing End at #{Time.now.to_s}")
      append_mode_file.close

      UserMailer.mail_report_status('import').deliver
    end
  end
end
