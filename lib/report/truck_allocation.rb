module Report
  class TruckAllocation
    def create_and_send
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 13, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10

        workbook.add_worksheet(name: "Truck Non Allocation Report") do |sheet|
          add_data(sheet, center, heading)
          sheet.column_widths nil, nil, nil, nil
        end
      end
      package.use_shared_strings = true
      package.serialize("#{Rails.root}/tmp/Truck_Allocation_#{time}.xlsx")
      UserMailer.non_truck_allocated_container_report.deliver
    end

    def add_data(sheet, center, heading)
      date = Date.today + 5.days
      imports = Import.joins(:import_items, :customer)
                     .select("imports.bl_number, imports.work_order_number, imports.equipment,
                              customers.name customer_name, import_items.last_loading_date loading_date,
                              imports.quantity, imports.customer_id, imports.estimate_arrival,
                              imports.bill_of_lading_id, imports.id")
                     .where("import_items.last_loading_date < ? AND import_items.status!='delivered'", date)
                     .where("import_items.truck_number iS NULL AND import_items.truck_id IS NULL").uniq
      non_truck_containers = ImportItem.joins(:import).where("import_items.truck_number IS NULL AND import_items.truck_id IS NULL").group("imports.id").count
      p non_truck_containers
      sheet.add_row ['Last Loading Date', 'BL Number', 'File Ref.', 'Equipment', 'Customer', 'Quantity'],
                    style: heading, height: 40
      imports.order("imports.estimate_arrival DESC").each do |import|
        last_loading_date = import.estimate_arrival.nil? ? "" : (import.estimate_arrival + 8.days).try(:to_date).try(:strftime,"%d-%b-%Y").to_s
        p "import id = #{import.id}"
        sheet.add_row [
                        last_loading_date,
                        import.bl_number.to_s,
                        import.work_order_number,
                        import.equipment.to_s,
                        import.customer_name,
                        non_truck_containers[import.id]
                      ]

      end
    end
  end
end
