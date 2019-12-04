module Report
  class DailyContainerReturned
    def create(customer_id, import_items)
      customer = Customer.find(customer_id)
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook
      @import_items = import_items

      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 13, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10

        workbook.add_worksheet(name: "Container Report") do |sheet|
          add_data(sheet, center, heading)
          sheet.column_widths nil, nil, nil, nil
        end
      end
      package.use_shared_strings = true
      package.serialize("#{Rails.root}/tmp/ContainerReturned_#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    end

    def add_data(sheet, center, heading)
      sheet.add_row ['Return Date', 'Container Number', 'Return Status', 'Location'],
                    style: heading, height: 40
      @import_items.order(g_f_expiry: :desc).each do |import_item|
        return_date = import_item.g_f_expiry.nil? ? "" : import_item.g_f_expiry.try(:to_date).try(:strftime,"%d-%b-%Y").to_s
        sheet.add_row [
                        return_date,
                        import_item.container_number.to_s,
                        import_item.return_status.try(:humanize),
                        import_item.dropped_location.to_s
                      ]
      end
    end
  end
end
