# frozen_string_literal: true

namespace "idf" do
  desc "Daily Customers Summary Email"
  task customer_summary_email: :environment do
    customers = LocalImport.where.not(status: :order_completed).pluck(:customer_id).uniq
    customers.each do |c|
      customer = Customer.find(c)
      local_imports = LocalImport.where(customer: c)
      history = local_imports.select {|l| l.status == "order_completed" }
      operations = local_imports.select {|l| l.status == "order_created" }
      idfs = local_imports.select {|l| l.status.nil? }

      p = Axlsx::Package.new
      # p.use_shared_strings = true
      wrap = p.workbook.styles.add_style alignment: {wrap_text: true}

      p.workbook.add_worksheet(name: "IDF") do |sheet|
        sheet.add_row ["OUR REF", "INV NO.", "SHIPPER", "DESCRIPTION", "GWT-KGS", "BL NO", "IDF NUMBER", "IDF DATE"]
        idfs.each do |l|
          sheet.add_row [l.reference_number, l.invoice_number, l.shipper, l.gwt, l.description, l.bl_number, l.idf_number, l.idf_date.to_s], style: wrap
        end
      end

      p.workbook.add_worksheet(name: "Active Shipments") do |sheet|
        sheet.add_row ["OUR REF", "Customer Reference", "SHIPPER", "GOODS DESCRIPTION", "CONTAINERS", "GWT- KGS", "BL NO",
                       "DATE ORIGINAL DOCS RECEIVED", "VESSEL", "ETA", "SHIPPING LINE", "RECEIPT OF EXEMPTION", "CUSTOMS ENTRY NO.",
                       "CUSTOMS PAYMENT DATE", "ALLOCATED TRUCK(S)", "REMARK(S)"]
        width = 10
        operations.each do |o|
          containers = "#{o.quantity} x #{o.equipment_type}"
          trucks = o.local_import_items.pluck(:truck).join(", ")
          remarks = o.remarks.map{|r| "#{r.category[0].upcase} - #{r.date.to_s} - #{r.desc}"}
          width = (remarks.max_by(&:length).to_s.length > width) ? remarks.max_by(&:length).to_s.length : width
          remarks =  remarks.join("\n")
          sheet.add_row [o.reference_number, o.customer_reference, o.shipper, o.description, containers,
                         o.gwt, o.bl_number, o.original_documents_date.to_s, o.vessel_name,
                         o.estimated_arrival.to_s, o.shipping_line.name, o.exemption_code_date.to_s,
                         o.customs_entry_number, o.customs_entry_date.to_s, trucks, remarks], style:  wrap
        end
        column_width = Array.new(16, 15)
        column_width[15] = width
        sheet.column_widths *column_width
      end

      p.workbook.add_worksheet(name: "History") do |sheet|
        sheet.add_row ["OUR REF", "Customer Reference", "SHIPPER", "GOODS DESCRIPTION", "CONTAINERS", "GWT- KGS", "BL NO",
                       "DATE ORIGINAL DOCS RECEIVED", "VESSEL", "ETA", "SHIPPING LINE", "RECEIPT OF EXEMPTION", "CUSTOMS ENTRY NO.",
                       "CUSTOMS PAYMENT DATE", "ALLOCATED TRUCK(S)", "REMARK(S)", "OFFLOADING DATE"]
        width = 10
        history.each do |h|
          containers = "#{h.quantity} x #{h.equipment_type}"
          trucks = h.local_import_items.pluck(:truck).join(", ")
          offloading_dates = h.local_import_items.pluck(:offloading_date).join(", ")
          remarks = h.remarks.map{|r| "#{r.category[0].upcase} - #{r.date.to_s} - #{r.desc}"}
          width = (remarks.max_by(&:length).to_s.length > width) ? remarks.max_by(&:length).to_s.length : width
          remarks =  remarks.join("\n")
          sheet.add_row [h.reference_number, h.customer_reference, h.shipper, h.description, containers,
                         h.gwt, h.bl_number, h.original_documents_date.to_s, h.vessel_name,
                         h.estimated_arrival.to_s, h.shipping_line.name, h.exemption_code_date.to_s,
                         h.customs_entry_number, h.customs_entry_date.to_s, trucks, remarks, offloading_dates], style:  wrap
        end
        column_width = Array.new(17, 15)
        column_width[15] = width
        sheet.column_widths *column_width
      end

      p.use_shared_strings = true
      filePath = "#{Rails.root}/tmp/"
      date = Date.today.strftime("%d-%m-%Y") + " "
      fileName = "#{date + customer.name}.xlsx"
      p.serialize(filePath + fileName)

      p "***** Sending email to Customer #{customer.name} ******"
      LocalImportMailer.customer_summary_email(customer, filePath, fileName).deliver
    end
  end
end
