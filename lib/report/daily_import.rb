module Report
  class DailyImport

    def create(customer)
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook
      @imports = customer.imports.includes(import_items: [:truck])

      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 12, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10

        {'Snapshot' => nil, 'In Transit' => nil, 'History' => 'delivered', 'Summary' => nil}.each do |name, status|
          workbook.add_worksheet(name: name) do |sheet|
            if name == 'Snapshot'
              add_snapshot_report(customer, sheet, center, heading, status)
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
              pane.x_split = 2
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
      sheet.add_row ['BL Number', 'Shipper', 'Desc', 'Equipment', 'Qty', 'ETA', 'Status', 'Remarks'],
                    style: heading, height: 40
      imports = @imports.where.not(status: 'ready_to_load')
      imports.each do |import|
        estimate_arrival = import.estimate_arrival.nil? ? "" : import.estimate_arrival.try(:to_date).try(:strftime,"%d-%b-%Y").to_s
        sheet.add_row [import.cargo_receipt, import.shipper, import.description, import.equipment,
                       import.quantity, estimate_arrival, import.status, import.remarks.external.try(:last).try(:desc)]
      end
      sheet.add_row
      sheet.add_row ['In Transit']
      sheet.add_row ['BL Number', 'Shipper', 'Desc', 'Container', 'Truck Number', 'Location', 'Status', 'Remarks'],
                    style: heading, height: 40
      imports = @imports.where(status: 'ready_to_load')
      imports.each do |import|
        import.import_items.each do |import_item|
          if import_item.delivered? && import_item.close_date
            start_date = Time.new(Time.zone.now.year, Time.zone.now.month, Time.zone.now.day)
            end_date = Time.new(import_item.close_date.year, import_item.close_date.month, import_item.close_date.day)
            difference_in_days = TimeDifference.between(start_date, end_date).in_days
            sheet.add_row [import.cargo_receipt, import.shipper, import.description, import_item.container_number,
                           import_item.truck.try(:reg_number), import_item.truck.try(:location), import_item.status,
                           import_item.remarks.external.try(:last).try(:desc)] if difference_in_days <= 3
          else
            sheet.add_row [import.cargo_receipt, import.shipper, import.description, import_item.container_number,
                           import_item.truck.try(:reg_number), import_item.truck.try(:location), import_item.status, import_item.remarks.external.try(:last).try(:desc)]
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
      #ImportItem.includes(:import).where.not(status: 'delivered').where(import_id: @imports.pluck(:id)).each do |import_item|
      #  import_item.import.update_attribute(:is_all_container_delivered, true)
      #end
      #import_items = ImportItem.where.not(status: 'delivered').select('import_id').uniq
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
                     "Container Discharged", "Ready to Load", "Truck Allocated",
                     "Loaded Out Of Port", "Arrived at Border", "Departed from Border", "Arrived at Destination",
                     "Truck Released"],
                  style: heading, height: 40
      if status
        @imports = customer.imports.includes(import_items: [:truck]).where("import_items.status" => status)
        @import_item_ids = ImportItem.where(import_id: @imports.pluck(:id)).pluck(:id)
        auditable_ids = @imports.pluck(:id) + @import_item_ids
        @audited_data = Espinita::Audit.where(auditable_id: auditable_ids,
                                              auditable_type: ['Import', 'ImportItem'])
        # imports = customer.imports.includes({import_items: :audits}, :audits).where("import_items.status" => status)
      else
        @imports = customer.imports.includes(import_items: [:truck]).where.not("import_items.status" => "delivered")
        @import_item_ids = ImportItem.where(import_id: @imports.pluck(:id)).pluck(:id)
        auditable_ids = @imports.pluck(:id) + @import_item_ids
        @audited_data = Espinita::Audit.where(auditable_id: auditable_ids,
                                              auditable_type: ['Import', 'ImportItem'])
        # imports = customer.imports.includes({import_items: :audits}, :audits).where.not("import_items.status" => "delivered")
      end


      h = {}
      @imports.each do |import|
        import.import_items.each do |item|
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
          # [import,item].each do |entity|
          #   audited_changes = entity.audits.collect(&:audited_changes)
          #   audited_changes.each do |a|
          #     if !a[:status].blank?  and !a[:status].first.eql?(a[:status].second) then
          #       h[a[:status].second] = [] if h[a[:status].second].nil?
          #       h[a[:status].second].unshift(a[:updated_at].try(:second).try(:to_date).try(:strftime, "%d-%b-%Y").to_s +
          #                                    " : " + (a[:remarks].nil? ? " " : a[:remarks].try(:second).to_s))
          #     else
          #       if !a[:remarks].blank? then
          #         h[a[:status].second] = [] if h[a[:status].second].nil?
          #         h[a[:status].second].unshift(a[:updated_at].try(:second).try(:to_date).try(:strftime, "%d-%b-%Y").to_s +
          #                                      " : " + a[:remarks].try(:second).to_s)
          #       end
          #     end
          #   end
          # end
          h.replace( h.merge(h) {|key, value| value = value.join("\n")} )

          max_height = 0
          h.each_value{|v| max_height = v.length if v.length > max_height}
          max_height = (max_height * 0.7) if max_height > 50

          sheet.add_row [import.cargo_receipt,
                     item.container_number, import.equipment, import.description,
                     import.estimate_arrival.nil? ? "" :
                     import.estimate_arrival.to_date.strftime("%d-%b-%Y"),
                     item.truck.try(:reg_number), h["copy_documents_received"],
                     h["original_documents_received"], h["container_discharged"],
                     h["ready_to_load"], h["truck_allocated"], h["loaded_out_of_port"],
                     (h["arrived_at_border"]), (h["departed_from_border"]), (h["arrived_at_destination"]),
                     h["delivered"]],
                     style: center, height: max_height

          h.clear
        end
      end


    end

  end
end
