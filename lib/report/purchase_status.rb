module Report
  class PurchaseStatus
    def create_and_send
      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 13, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10

        workbook.add_worksheet(name: "Purchase Order Status") do |sheet|
          add_data(sheet, center, heading)
          sheet.column_widths nil, nil, nil, nil
        end
      end
      package.use_shared_strings = true
      package.serialize("#{Rails.root}/tmp/PurchaseOrderStatus_#{time}.xlsx")
      UserMailer.purchase_order_status_report.deliver
    end

    def add_data(sheet, center, heading)
      date = Date.yesterday #we are going to send this mail at 1 am so checking for yesterday
      purchase_order_items = PurchaseOrderItem.select("purchase_orders.number po_number,
                             purchase_orders.date po_date, suppliers.name supplier_name,
                             spare_parts.product_name part_name, purchase_order_items.quantity,
                             purchase_order_items.price, purchase_order_items.total_price")
                             .joins(:spare_part, purchase_order:[:supplier]).where("purchase_orders.date=?", date)
                             .order("suppliers.name")
      sheet.add_row ['Date', 'LPO Number', 'Vendor', 'Spare Part', 'Qty', 'Rate', 'Amount'],
                    style: heading, height: 40
      purchase_order_items.each do |purchase_item|
        date = purchase_item.po_date.nil? ? "" : purchase_item.po_date.try(:to_date).try(:strftime,"%d-%b-%Y").to_s
        sheet.add_row [
                        date,
                        purchase_item.po_number.to_s,
                        purchase_item.supplier_name,
                        purchase_item.part_name.to_s,
                        purchase_item.quantity,
                        purchase_item.price,
                        purchase_item.total_price
                      ]

      end
    end
  end
end
