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
      customers.each do |customer|
        UserMailer.mail_report(customer,'export').deliver
      end
    end

    def daily_report_import
      customers = []
      import_items = ImportItem.where.not(status: "delivered").select(:import_id).uniq
      import_items.each do |item|
        import = Import.find(item.import_id)
        customers.push(import.customer)
      end
      customers = customers.uniq
      customers.each do |customer|
        begin
          UserMailer.mail_report(customer,'import').deliver
        rescue Exception => e
          UserMailer.error_mail_report(customer, e).deliver
        end
      end
    end
  end
end
