module Report

  class Daily

    def create
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      customers = Customer.includes({exports: :export_items})
      customers.each do |customer|  
        package = Axlsx::Package.new
        workbook = package.workbook
        workbook.styles do |s|
          heading = s.add_style alignment: {horizontal: :center}, 
                                b: true, sz: 12, bg_color: "4F81BD", wrap_text: true,
                                 :border => {:style => :thin, :color => "00"}
          center = s.add_style alignment: {horizontal: :center}, 
                                :border => {:style => :thin, :color => "00" }
          column_style = s.add_style alignment: {horizontal: :center}, bg_color: "E6E0EC",
                               :border => {:style => :thin, :color => "00" }
			    
          workbook.add_worksheet(name: "Under Clearance") do |sheet|
      	 
  				  add_under_clearance_worksheet(customer,sheet,heading,center)
            sheet.col_style 2, column_style,  row_offset: 1
            sheet.col_style 5, column_style,  row_offset: 1
          end

          workbook.add_worksheet(name: "HANDED OVER") do |sheet|
            add_handed_over_worksheet(customer,sheet,heading,center)
            sheet.col_style 2, column_style,  row_offset: 1
            sheet.col_style 5, column_style,  row_offset: 1
          end
        end 
        package.use_shared_strings = true
        package.serialize("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx", 
      	                 filename: "#{customer.name.tr(" ", "_")}_#{time}.xlsx", 
      	                 type: "application/vnd.ms-excel")
      end
    end

    def add_under_clearance_worksheet(customer,sheet,heading,center)
      sheet.add_row ["Truck No", "Booking No", "Vessal Targeted", "POL", "POD",
                      "Container", "Type", "weight", "shipping Line","shipping seal",
                      "customer seal","Loaded date","Arrived at Malaba Border",
                      "Crossed Malaba Border","Order Release Date","Arrived Port date",
                      "Document Handed Date", "Current Status"],
                      style: heading, height: 40
         

      customer.exports.each do |export|
        export.export_items.each do |item|
          movements = Movement.where(id: item.movement_id)
          movements.each do |movement|
            
            h ={}
            movement.audits.to_a.collect(&:audited_changes).each do |a|
              if !a[:status].blank? then
                h[a[:status].second] = a[:updated_at].second.to_date.strftime("%d-%b-%Y")
              end
            end
                    
            sheet.add_row [movement.truck_number, movement.booking_number,
                  movement.vessel_targeted, movement.port_of_destination, 
                  movement.port_of_loading, item.container, export.export_type,
                  export.equipment, export.shipping_line, movement.shipping_seal,
                  movement.custom_seal, h["loaded"], h["arrived_malaba_border"], 
                  h["crossed_malaba_border"], h["order_released"], h["arrived_port"],
                  h["document_handed"], movement.current_location], style: center
                  
            h.clear
          end
        end
      end

    end

    def add_handed_over_worksheet(customer,sheet,heading,center)
      sheet.add_row ["Truck No", "Booking No", "Vessal Targeted", "POL", "POD",
                      "Container", "Type", "weight", "shipping Line","shipping seal",
                      "customer seal","Loaded date","Arrived at Malaba Border",
                      "Crossed Malaba Border","Order Release Date","Arrived Port date",
                      "Document Handed Date", "Current Status"],
                      style: heading, height: 40
         

      customer.exports.each do |export|
        export.export_items.each do |item|
          movements = Movement.where(id: item.movement_id, status: 'document_handed')
          movements.each do |movement|
            
            h ={}
            movement.audits.to_a.collect(&:audited_changes).each do |a|
              if !a[:status].blank? then
                h[a[:status].second] = a[:updated_at].second.to_date.strftime("%d-%b-%Y")
              end
            end
                    
            sheet.add_row [movement.truck_number, movement.booking_number,
                  movement.vessel_targeted, movement.port_of_destination, 
                  movement.port_of_loading, item.container, export.export_type,
                  export.equipment, export.shipping_line, movement.shipping_seal,
                  movement.custom_seal, h["loaded"], h["arrived_malaba_border"], 
                  h["crossed_malaba_border"], h["order_released"], h["arrived_port"],
                  h["document_handed"], movement.current_location], style: center
                  
            h.clear
          end
        end
      end

    end
  
  end

end