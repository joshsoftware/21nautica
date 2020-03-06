module Report
  class DailyImport

    def create(customer)
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook
      @imports = customer.imports.includes(import_items: [:truck])

      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 13, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10

        {'Snapshot' => nil, 'In Transit' => nil, 'History' => 'delivered', 'Summary' => nil}.each do |name, status|
          workbook.add_worksheet(name: name) do |sheet|
            if name == 'Snapshot'
              add_snapshot_report(customer, sheet, center, heading, status)
              sheet.column_widths nil, nil, nil, nil, nil, nil,
                                  nil, nil, nil, nil, nil, nil, 70
            elsif name == 'Summary'
              add_summary_data(customer, sheet, center, heading, status)
            else
              add_data(customer, sheet, center, heading, status)
              sheet.column_widths nil,nil,nil,nil,nil,nil,30,30,
                                    25,25,25,25,30,33,30,25
            end
            sheet.sheet_view.pane do |pane|
              pane.state = :frozen
              pane.y_split = 1
              pane.x_split = 3
              pane.active_pane = :bottom_right
            end
          end
        end
      end
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")

    end

    def add_snapshot_report(customer, sheet, center, heading, status)
      sheet.add_row ['In Port']
      sheet.add_row ['Ref Number', 'BL Number', 'Shipper', 'Desc', 'Equipment', 'Qty', 'ETA', 'Copy Doc','OBL', 'DO', 'Rotation #', 'Entry Date', 'Remarks'],
                    style: heading, height: 40
      imports = @imports.not_ready_to_load
      # imports = @imports.where("imports.status!='ready_to_load' OR (imports.bl_received_at IS NULL AND imports.entry_number IS NULL AND imports.entry_type IS NULL)")
      imports.each do |import|
        estimate_arrival = import.estimate_arrival.nil? ? "" : import.estimate_arrival.try(:to_date).try(:strftime,"%d-%b-%Y").to_s
        entry_date = import.estimate_arrival.nil? ? "" : import.estimate_arrival.try(:to_date).try(:strftime,"%d-%b-%Y").to_s
        remarks = import.remarks.external.last(3).map {|rem| rem.created_at.try(:strftime,"%d-%b-%Y").to_s + " - "+ rem.desc}
        sheet.add_row [import.work_order_number, import.cargo_receipt, import.shipper, import.description, import.equipment, import.quantity, estimate_arrival,
          import.created_at.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
          import.bl_received_at.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
          import.do_received_at.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
          import.rotation_number,
          import.entry_date.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
          remarks.join("\n"), ]
      end
      sheet.add_row
      sheet.add_row ['In Transit']
      sheet.add_row ['Ref Number','BL Number', 'Shipper', 'Desc', 'Container', 'Truck Number', 'Location', 'Status','OBL','DO','Rotation#', 'Entry Date', 'Remarks', 'Truck Allocated', 'Ready to Load', 'Loaded Out Of Port', 'Arrived At Border', 'Arrived At Destination', 'Empty Container Status'],
                    style: heading, height: 40
      imports = @imports.ready_to_load
      # imports = @imports.where("imports.status='ready_to_load' OR (imports.bl_received_at IS NOT NULL AND imports.entry_number IS NOT NULL AND imports.entry_type IS NOT NULL)")
      imports.each do |import|
        import.import_items.where("(import_items.status != ? or import_items.status IS ?) and (import_items.return_status != ? or import_items.return_status IS ?)", "delivered", nil, 0, nil).where("import_items.interchange_number IS NULL").includes(:status_date).each do |import_item|
          status_date_array = []
          status_date = import_item.status_date
          if status_date
            status_date_array = [status_date.truck_allocated.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
             status_date.ready_to_load.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
             status_date.loaded_out_of_port.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
             status_date.arrived_at_border.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
             status_date.arrived_at_destination.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
             import_item.return_status.to_s]
          end          
          if import_item.delivered? && import_item.close_date
            start_date = Time.new(Time.zone.now.year, Time.zone.now.month, Time.zone.now.day)
            end_date = Time.new(import_item.close_date.year, import_item.close_date.month, import_item.close_date.day)
            difference_in_days = TimeDifference.between(start_date, end_date).in_days
            sheet.add_row [import.work_order_number, import.cargo_receipt, import.shipper, 
              import.description, import_item.container_number, import_item.truck.try(:reg_number), 
              import_item.truck.try(:location), import_item.status,
              import.bl_received_at.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
              import.do_received_at.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
              import.rotation_number,
              import.entry_date.try(:to_date).try(:strftime,"%d-%b-%Y").to_s,
              import_item.remarks.external.try(:last).try(:desc),
            ] + status_date_array if difference_in_days <= 3
          else
            sheet.add_row [import.work_order_number, import.cargo_receipt, import.shipper, import.description, import_item.container_number,
                           import_item.truck.try(:reg_number), import_item.truck.try(:location), import_item.status, import.bl_received_at.try(:to_date).try(:strftime,"%d-%b-%Y").to_s, import.do_received_at.try(:to_date).try(:strftime,"%d-%b-%Y").to_s, import.rotation_number, import.entry_date.try(:to_date).try(:strftime,"%d-%b-%Y").to_s, import_item.remarks.external.try(:last).try(:desc)] + status_date_array
          end
        end
      end
    end

    def add_summary_data(customer, sheet, center, heading, status)
      sheet.add_row ['BL Number', 'Goods Description', 'ETA', 'Equipment x Qty', 'Last Status Update', 'Remarks'],
                    style: heading, height: 40

      @imports.each do |import|
        import.update_attribute(:is_all_container_delivered, true) if import.import_items.where.not(status: 'delivered').count.zero?
      end
      Import.where(customer: customer, is_all_container_delivered: false).each do |import|
          bl_number = import.cargo_receipt
          goods_description = import.description
          estimate_arrival = import.estimate_arrival.nil? ? "" : import.estimate_arrival.try(:to_date).try(:strftime,"%d-%b-%Y").to_s
          equipment_quantity = "#{import.equipment} " '*' " #{import.quantity}"
          last_status_update = import.status
          remarks = import.remarks.external.try(:last).try(:desc)

          sheet.add_row [bl_number, goods_description, estimate_arrival, equipment_quantity, last_status_update, remarks], style: center, 
                                                                                        widths: [:igonre, :auto], height: 40
      end
    end

    def add_data(customer, sheet, center, heading, status)
      sheet.add_row ["BL Number", "Container Number", "Size",
                     "Goods Description", "ETA", "Truck Number",
                     "Copy Documents Received", "Original Documents Received",
                     "Ready to Load", "Truck Allocated",
                     "Loaded Out Of Port", "Arrived at Border", "Departed from Border", "Arrived at Destination",
                     "Truck Released"],
                  style: heading, height: 40
      if status
        @imports = customer.imports.includes(import_items: [:truck]).where.not("import_items.interchange_number" => nil)
        @import_item_ids = ImportItem.where(import_id: @imports.pluck(:id)).pluck(:id)
        auditable_ids = @imports.pluck(:id) + @import_item_ids
        @audited_data = Espinita::Audit.where(auditable_id: auditable_ids,
                                              auditable_type: ['Import', 'ImportItem'])
      else
        @imports = customer.imports.includes(import_items: [:truck]).where("import_items.interchange_number" => nil)
        @import_item_ids = ImportItem.where(import_id: @imports.pluck(:id)).pluck(:id)
        auditable_ids = @imports.pluck(:id) + @import_item_ids
        @audited_data = Espinita::Audit.where(auditable_id: auditable_ids,
                                              auditable_type: ['Import', 'ImportItem'])
      end


      h = {}
      @imports.order(:id).each do |import|
        import.import_items.includes(:status_date).order(:id).each do |item|
          if item.status_date
            status_date = item.status_date
            h["ready_to_load"] = [status_date.ready_to_load.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s]
            h["truck_allocated"] = [status_date.truck_allocated.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s]
            h["loaded_out_of_port"] = [status_date.loaded_out_of_port.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s]
            h["arrived_at_border"] = [status_date.arrived_at_border.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s]
            h["arrived_at_destination"] = [status_date.arrived_at_destination.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s]
            h["delivered"] = [status_date.delivered.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s]
            h["departed_from_border"] = [status_date.departed_from_border.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s]
            
          else
            [import, item].each do |entity|
              class_name = entity.class.name == "Import" ? "Import" : "ImportItem"
              audits = @audited_data.select { |audit| audit.auditable_id == entity.id && audit.auditable_type == class_name}
              audits.each do |audit|
                a = audit.audited_changes
                if !a[:status].blank?  and !a[:status].first.eql?(a[:status].second) then
                  h[a[:status].second] = [] if h[a[:status].second].nil?
                  h[a[:status].second].unshift(a[:updated_at].try(:second).try(:to_date).try(:strftime, "%d-%b-%Y").to_s +
                                               " : " + (a[:remarks].nil? ? " " : a[:remarks].try(:second).to_s))
                else
                  if !a[:remarks].blank? then
                    h[a[:status].second] = [] if h[a[:status].second].nil?
                    h[a[:status].second].unshift(a[:updated_at].try(:second).try(:to_date).try(:strftime, "%d-%b-%Y").to_s +
                                                 " : " + a[:remarks].try(:second).to_s)
                  end
                end
              end
            end
          end
          h.replace( h.merge(h) {|key, value| value = value.join("\n")} )

          max_height = 0
          h.each_value{|v| max_height = v.length if v.length > max_height}
          max_height = (max_height * 0.7) if max_height > 50

          sheet.add_row [import.cargo_receipt,
                     item.container_number, import.equipment, import.description,
                     import.estimate_arrival.nil? ? "" :
                     import.estimate_arrival.to_date.strftime("%d-%b-%Y"),
                     item.truck.try(:reg_number), import.created_at.to_date.strftime("%d-%b-%Y"),
                     import.bl_received_at.try(:to_date).try(:strftime, "%d-%b-%Y" ).to_s,
                     h["ready_to_load"], h["truck_allocated"], h["loaded_out_of_port"],
                     h["arrived_at_border"], h["departed_from_border"],
                     h["arrived_at_destination"], h["delivered"] ],
                     style: center, height: max_height

          h.clear
        end
      end


    end

  end
end
