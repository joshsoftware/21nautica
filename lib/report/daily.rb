require 'axlsx'
require 'date'

module Report

  class Daily

    def create
      time = Time.now.to_s
      time = DateTime.parse(time).strftime("%d_%b_%Y")
      customers = Customer.includes({exports: :export_items})
      customers.each do |customer|  
        package = Axlsx::Package.new
        workbook = package.workbook
      
			  workbook.add_worksheet(name: "Under Clearance") do |sheet|
      	  workbook.styles do |s|
  				  heading = s.add_style alignment: {horizontal: :center}, 
  				                      b: true, sz: 14, 
  				                      bg_color: "4F81BD"
            center = s.add_style alignment: {horizontal: :center}
				    sheet.add_row ["Truck No", "Booking No", "Vessal Targeted", "POL", "POD",
                             "Container", "Type", "weight", "shipping Line",
                              "shipping seal", "customer seal"],
                             style: heading, height: 40
				 

            customer.exports.each do |export|
              export.export_items.each do |item|
                movements = Movement.where(id: item.movement_id)
                movements.each do |movement|
                  sheet.add_row [movement.truck_number, movement.booking_number,
                     movement.vessel_targeted, movement.port_of_destination, 
                      movement.port_of_loading, item.container, export.export_type,
                       export.equipment, export.shipping_line, movement.shipping_seal,
                        movement.custom_seal], style: center
                end
              end
            end
          end

        end
        package.use_shared_strings = true
        package.serialize("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx", 
      	                 filename: "#{customer.name.tr(" ", "_")}_#{time}.xlsx", 
      	                 type: "application/vnd.ms-excel")
      end
    end

  end
end