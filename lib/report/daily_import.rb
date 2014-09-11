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
          end
        end
      end
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")

    end


    def add_data(customer, sheet, center, heading, status)
      sheet.add_row ["BL Number", "Container Number", "Size",
                     "Goods Description", "ETA", "Truck Number",
                     "Copy Documents Received", "Original Documents Received",
                     "Container Discharged", "Ready to Load", "Truck Allocated",
                     "Loaded Out Of Port", "Arrived at Malaba", "Departed From Malaba" ,
                     "Arrived at Kampala", "Truck Released"],
                  style: heading, height: 40
      if status
        imports = customer.imports.includes({import_items: :audits}, :audits).where("import_items.status" => status)
      else
        imports = customer.imports.includes({import_items: :audits}, :audits).where.not("import_items.status" => "delivered")
      end

      h = {}
      imports.each do |import|
        import.import_items.each do |item|
          [import,item].each do |entity|
            audited_changes = entity.audits.collect(&:audited_changes)

            if !status
              audited_changes.reverse!
            end

            audited_changes.each do |a|

              if !a[:status].blank?  and !a[:status].first.eql?(a[:status].second) then
                h[a[:status].second] = [] if h[a[:status].second].nil?
                h[a[:status].second].unshift(a[:updated_at].second.to_date.strftime("%d-%b-%Y") +
                                             " : " + (a[:remarks].nil? ? " " : a[:remarks].second))
              else
                if !a[:remarks].blank? then
                  h[a[:status].second] = [] if h[a[:status].second].nil?
                  h[a[:status].second].unshift(a[:updated_at].second.to_date.strftime("%d-%b-%Y") +
                                               " : " + a[:remarks].second)
                end
              end


            end
          end
          h.replace( h.merge(h) {|key, value| value = value.join("\n")} )

          sheet.add_row [import.bl_number,
                     item.container_number, import.equipment, import.description,
                     import.estimate_arrival.nil? ? "" :
                     import.estimate_arrival.to_date.strftime("%d-%b-%Y"),
                     item.truck_number,h["copy_documents_received"],
                     h["original_documents_received"], h["container_discharged"],
                     h["ready_to_load"], h["truck_allocated"], h["loaded_out_of_port"],
                     h["arrived_at_malaba"], h["departed_from_malaba"],
                     h["arrived_at_kampala"], h["delivered"]],
                     style: center, height: 25

          h.clear
        end
      end


    end

  end
end
