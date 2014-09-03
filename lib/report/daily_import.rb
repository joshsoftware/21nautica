module Report
  class DailyImport

    def create(customer)
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 12, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10

        # 2 worksheets in the workbook
        {'In Transit' => nil, 'History' => 'delivered'}.each do |name, status|
          workbook.add_worksheet(name: name) do |sheet|
            add_data(customer, sheet, center, heading, status)
            sheet.column_info[7].width = 50
          end
        end
      end
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")

    end

    def add_data(customer, sheet, center, heading, status)
      sheet.add_row ["Work Order No", "BL Number", "Container Number", "Size",
                     "Goods Description", "ETA", "Out Of Port Date", "Full remarks",
                     "Truck Number", "Trailer Number", "Bond Direction", "Bond Number"],
                  style: heading, height: 40
      if status
        imports = customer.imports.includes({import_items: :audits}, :audits).where("import_items.status" => status)
      else
        imports = customer.imports.includes({import_items: :audits}, :audits).where.not("import_items.status" => "delivered")
      end

      imports.each do |import|
        import.import_items.each do |item|
          full_remarks = ""
          out_of_port_date = ""
          [import,item].each do |entity|
            entity.audits.collect(&:audited_changes).each do |a|
              if !a[:status].blank? then
                full_remarks.concat(a[:updated_at].second.to_date.strftime("%d-%b-%Y") +
                                      " " + a[:status].second + "\n")
                if a[:status].second.eql?("enroute_nairobi")
                  out_of_port_date = a[:updated_at].second.to_date.strftime("%d-%b-%Y")
                end
              end
            end
            entity.remarks.nil? ? full_remarks : full_remarks.concat("Remarks:" +
                                                  entity.remarks + "\n")
          end

          sheet.add_row [import.work_order_number, import.bl_number,
                     item.container_number, import.equipment, import.description,
                     import.estimate_arrival.nil? ? "" :
                     import.estimate_arrival.to_date.strftime("%d-%b-%Y"),
                     out_of_port_date, full_remarks, item.truck_number, item.trailer_number,
                     item.bond_direction, item.bond_number], style: center, height: 200

          full_remarks.clear


        end
      end


    end

  end
end
