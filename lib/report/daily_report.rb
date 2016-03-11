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
        f.puts("Processing - #{customer.name}")
        UserMailer.mail_report(customer,'export').deliver
        f.puts("Completed - #{customer.name}")
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

      customers.each do |customer|
        begin
          f.puts("Processing - #{customer.name}")
          UserMailer.mail_report(customer,'import').deliver
          f.puts("Completed - #{customer.name}")
        rescue Exception => e
          UserMailer.error_mail_report(customer, e).deliver
        end
      end
      f.puts("Processing End at #{Time.now.to_s}")
      f.close

      UserMailer.mail_report_status('import').deliver
    end
  end
end
