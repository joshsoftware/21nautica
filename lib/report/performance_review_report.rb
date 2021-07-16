module Report
  class PerformanceReviewReport

    def create_report(worksheet_name, from_date, to_date)
      package = Axlsx::Package.new
      workbook = package.workbook
      workbook.add_worksheet(name: "#{worksheet_name}") do |sheet|
        sheet.add_row ['Customer Name', 'BL Number', 'Container Number', 'ETA', 'OBL Date', 'Customs Entry Date', 'Truck Allocated Date',
                       'Loaded out of port Date', 'Arrived at the border Date', 'Arrived at Destination Date', 'DO Date']

        import_items = ImportItem.where(import_id: Import.where('estimate_arrival >= ? and estimate_arrival <= ?', from_date, to_date).pluck(:id))
        import_items.each do |import_item|
          customer_name = import_item.customer_name
          container_number = import_item.container_number
          
          bl_number = import_item.import.bl_number
          estimate_arrival_time = import_item.import.estimate_arrival
          obl_date = import_item.import.try(:bl_received_at)
          customer_entry_date = import_item.import.try(:entry_date)

          truck_allocated = import_item.try(:status_date).try(:truck_allocated)
          loaded_out_of_port = import_item.try(:status_date).try(:loaded_out_of_port)
          arrived_at_border = import_item.try(:status_date).try(:arrived_at_border)
          arrived_at_destination = import_item.try(:status_date).try(:arrived_at_destination)
          delivery_order_date = import_item.try(:status_date).try(:delivered)

          sheet.add_row [customer_name, bl_number, container_number, estimate_arrival_time, obl_date, customer_entry_date,
                         truck_allocated, loaded_out_of_port, arrived_at_border, arrived_at_destination, delivery_order_date]
        end
      end
      package.use_shared_strings = true
      package.serialize("#{Rails.root}/tmp/#{worksheet_name}.xlsx")
    end
  end
end
