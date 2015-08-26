module Report
  class Daily

    def create(customer)
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook
      exports = customer.exports.includes(:export_items)

      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 12, bg_color: "4F81BD", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {horizontal: :center},
          :border => {:style => :thin, :color => "00" }
        column_style = s.add_style alignment: {horizontal: :center}, bg_color: "E6E0EC",
          :border => {:style => :thin, :color => "00" }

        # 2 worksheets in the workbook
        { 'Under Clearnance' => nil, 'HANDED OVER' => 'container_handed_over_to_KPA',
      'empty cntrs' => 'empty_containers'}.each do |name, status|
          workbook.add_worksheet(name: name) do |sheet|
            if !status.eql?('empty_containers') then
              add_data(exports, sheet, center, heading, status)
            else
              add_empty_cntr_data(exports, sheet, heading, center)
            end
            sheet.col_style 2, column_style,  row_offset: 1
            sheet.col_style 5, column_style,  row_offset: 1

            sheet.sheet_view.pane do |pane|
              pane.state = :frozen
              pane.y_split = 1
              pane.active_pane = :bottom_right
            end

          end
        end
      end
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx")

    end

    def add_data(exports, sheet, center, heading, status)
      sheet.add_row ["Truck No", "Booking No", "Vessal Targeted", "POL", "POD",
                  "Container", "Type", "weight", "shipping Line","shipping seal",
                  "customer seal","Loaded date","Arrived at Malaba Border",
                  "Crossed Malaba Border","Order Release Date","Arrived Port date",
                  "Document Handed Date", "Current Status"],
                  style: heading, height: 40

      exports.each do |export|
        export.export_items.each do |item|
          movements = Movement.where(id: item.movement_id)
          if status
            movements = movements.where(status: status) # special cases
          else
            movements = movements.where.not(status: 'container_handed_over_to_KPA')
          end

          movements.each do |movement|

            h ={}
            movement.audits.collect(&:audited_changes).each do |a|
              if !a[:status].blank? then
                h[a[:status].second] = a[:updated_at].second.to_date.strftime("%d-%b-%Y")
              end
            end

            sheet.add_row [movement.truck_number, movement.booking_number,
                     movement.vessel_targeted, movement.port_of_loading,
                     movement.port_of_discharge, item.container, export.equipment,
                     item.weight, export.shipping_line.try(:name), movement.shipping_seal,
                     movement.custom_seal, h["loaded"], h["under_customs_clearance"],
                     h["enroute_mombasa"],
                     h["arranging_shipping_order_and_vessel_nomination"],
                     h["arrived_port"],h["container_handed_over_to_KPA"],
                     movement.remarks], style: center

            h.clear
          end
        end
      end
    end

    def add_empty_cntr_data(exports, sheet, heading,center)
      sheet.add_row ["Date Of Placement", "Release Order Number",
                  "Container Number", "Location", "shipping Line",
                  "Number Of Days since Placed"], style: heading, height: 40

      exports.each do |export|
        export_items = export.export_items.where(movement_id: nil)
        export_items.each do |item|
          sheet.add_row [item.date_of_placement.to_date.strftime("%d-%b-%Y"),
                    export.release_order_number,
                    item.container.nil? ? "TBA" : item.container,
                    item.location, export.shipping_line.try(:name),
                    (DateTime.now- item.date_of_placement).to_i],style: center
        end
      end
    end

  end
end
