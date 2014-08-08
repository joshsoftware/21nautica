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
        { 'Under Clearnance' => nil, 'HANDED OVER' => 'document_handed',
      'empty cntrs' => 'empty_containers'}.each do |name, status|
          workbook.add_worksheet(name: name) do |sheet|
            sheet.add_row ["Truck No", "Booking No", "Vessal Targeted", "POL", "POD",
                     "Container", "Type", "weight", "shipping Line","shipping seal",
                     "customer seal","Loaded date","Arrived at Malaba Border",
                     "Crossed Malaba Border","Order Release Date","Arrived Port date",
                     "Document Handed Date", "Current Status"],
                     style: heading, height: 40
            if !status.eql?('empty_containers') then
              add_data(exports, sheet, center, status)
            else
              add_empty_cntr_data(exports, sheet, center)
            end
            sheet.col_style 2, column_style,  row_offset: 1
            sheet.col_style 5, column_style,  row_offset: 1
          end
        end
      end 
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx",
                        filename: "#{customer.name.tr(" ", "_")}_#{time}.xlsx", 
                          type: "application/vnd.ms-excel")

    end

    def add_data(exports, sheet, center, status)
      exports.each do |export|
        export.export_items.each do |item|
          movements = Movement.where(id: item.movement_id)
          movements = movements.where(status: status) if status # special cases

          movements.each do |movement|

            h ={}
            movement.audits.collect(&:audited_changes).each do |a|
              if !a[:status].blank? then
                h[a[:status].second] = a[:updated_at].second.to_date.strftime("%d-%b-%Y")
              end
            end

            sheet.add_row [movement.truck_number, movement.booking_number,
                     movement.vessel_targeted, movement.port_of_discharge, 
                     movement.port_of_loading, item.container, export.equipment,
                     item.weight, export.shipping_line, movement.shipping_seal,
                     movement.custom_seal, h["loaded"], h["arrived_malaba_border"], 
                     h["crossed_malaba_border"], h["order_released"], h["arrived_port"],
                     h["document_handed"], movement.current_location], style: center

            h.clear
          end
        end
      end
    end

    def add_empty_cntr_data(exports, sheet, center)
      exports.each do |export|
        export_items = export.export_items.where(movement_id: nil)
        export_items.each do |item|
          sheet.add_row [nil, nil, nil, nil, nil,
                    item.container.nil? ? "TBL" : item.container, export.equipment,
                    item.weight, export.shipping_line, nil, nil, nil, nil, nil, nil,
                    nil, nil], style: center
        end
      end
    end

  end
end
