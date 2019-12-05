module Report
  class DailyFuelLedger
    def fuel_ledger
      package = Axlsx::Package.new
      workbook = package.workbook
      worksheet_name = "Fuel ledger #{Date.yesterday}"
      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 13, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10
        workbook.add_worksheet(name:worksheet_name) do|sheet|
          add_data(sheet,heading,center)
        end
      end
      package.use_shared_strings = true
      package.serialize("#{Rails.root}/tmp/Fuel Ledger_#{Date.yesterday}.xlsx")
    end 

    def add_data(sheet,heading,center)
      date = Date.yesterday
      @fuel_entries = FuelEntry.includes(:truck).where(date:date).order(:id)
      sheet.add_row ['Date','Purchase / Dispense','Quantity', 'Total Available Fuel','Truck','Office Vehicle
        ','Fuel Cost($)','Physical Stock Adjustment'], style: heading, height: 40
      @fuel_entries.each do|fuel_entry|
        quantity = fuel_entry.quantity
        cost = fuel_entry.cost
        available =fuel_entry.available
        is_adjustment =fuel_entry.is_adjustment
        truck = fuel_entry.truck_id.nil? ? "" : fuel_entry.truck.reg_number
        office_vehicle = fuel_entry.office_vehicle.nil? ? "" : fuel_entry.office_vehicle
        purchased_dispensed = fuel_entry.purchased_dispensed
        sheet.add_row [date,purchased_dispensed,quantity,available,truck,office_vehicle,cost,is_adjustment]
      end
    
    end
  end
end
