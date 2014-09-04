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
      sheet.add_row ["Work Order No", "BL Number", "Container Number", "Size",
                     "Goods Description", "ETA", "Truck Number", "Trailer Number",
                     "Bond Direction", "Bond Number", "Copy Documents Received",
                     "Original Documents Received", "Vessel Arrived", "Container Discharged",
                     "Customs Entry Passed", "Release Order Secured", "Truck Allocated",
                     "Loaded Out Of Port", "Crossed Nairobi", "Arrived Malaba",
                     "Clearance Complete" , "Arrived at Kampala", "Item Delivered"],
                  style: heading, height: 40
      if status
        imports = customer.imports.includes({import_items: :audits}, :audits).where("import_items.status" => status)
      else
        imports = customer.imports.includes({import_items: :audits}, :audits).where.not("import_items.status" => "delivered")
      end

      h = {}; h1 = {}
      imports.each do |import|
        import.import_items.each do |item|
          [import,item].each do |entity|
            entity.audits.collect(&:audited_changes).each do |a|

              if !a[:status].blank?  and !a[:status].first.eql?(a[:status].second) then
                h[a[:status].second].nil? ?  h[a[:status].second] = [] : " "
                h[a[:status].second].unshift("ON: "+ a[:updated_at].second.to_date.strftime("%d-%b-%Y"))
              end

              if !a[:remarks].blank? then
                h[a[:status].second].nil? ? h[a[:status].second] = [] : " "
                h[a[:status].second].unshift(a[:remarks].second)
                p a[:status].second + a[:remarks].second
              end



            end
          end
          h.each_pair{|key, value| h1[key] = value.join("\n")}

          sheet.add_row [import.work_order_number, import.bl_number,
                     item.container_number, import.equipment, import.description,
                     import.estimate_arrival.nil? ? "" :
                     import.estimate_arrival.to_date.strftime("%d-%b-%Y"),
                     item.truck_number, item.trailer_number,
                     item.bond_direction, item.bond_number, h1["awaiting_original_documents"],
                     h1["awaiting_vessel_arrival_and_manifest"], h1["awaiting_container_discharge"],
                     h1["awaiting_customs_release"], h1["awaiting_release_order"],
                     h1["awaiting_truck_allocation"], h1["truck_allocated"],
                     h1["enroute_nairobi"], h1["enroute_malaba"], h1["awaiting_clearance"],
                     h1["enroute_kampala"], h1["arrived_kampala"], h1["delivered"]],
                     style: center, height: 50

          h.clear
          h1.clear


        end
      end


    end

  end
end
