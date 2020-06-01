class LocalImportMailer < ActionMailer::Base
  default from: ENV["EMAIL_FROM"]
  default from: ["info@reliablefreight.co.ke"] if Rails.env == "development"

  def new_idf_email(local_import)
    @local_import = local_import
    @customer = local_import.customer
    emails = @customer.emails.to_s.split(",")

    p = Axlsx::Package.new
    p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
      sheet.add_row ["OUR REF", "INV NO.", "SHIPPER", "DESCRIPTION", "GWT-KGS", "BL NO", "IDF NUMBER", "IDF DATE"]
      sheet.add_row [local_import.reference_number, local_import.invoice_number, local_import.shipper, local_import.gwt,
                     local_import.description, local_import.bl_number, local_import.idf_number, local_import.idf_date]
    end
    p.use_shared_strings = true
    filePath = "#{Rails.root}/tmp/"
    fileName = "IDF-#{@local_import.idf_date}.xlsx"
    p.serialize(filePath + fileName)

    attachments[fileName] = File.read(filePath + fileName)
    mail(to: emails, subject: "New IDF Created")
    File.delete(filePath + fileName)
  end

  def new_order_email(local_import)
    @local_import = local_import
    @customer = local_import.customer
    emails = @customer.emails.to_s.split(",")
    containers = "#{local_import.quantity} x #{local_import.equipment_type}"
    trucks = local_import.local_import_items.pluck(:truck).join(', ')

    p = Axlsx::Package.new
    p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
      sheet.add_row ["OUR REF", "Customer Reference", "SHIPPER", "GOODS DESCRIPTION", "CONTAINERS", "GWT- KGS", "BL NO",
                     "DATE ORIGINAL DOCS RECEIVED", "VESSEL", "ETA", "SHIPPING LINE", "RECEIPT OF EXEMPTION", "CUSTOMS ENTRY NO.",
                     "CUSTOMS PAYMENT DATE", "ALLOCATED TRUCK(S)"]
      sheet.add_row [local_import.reference_number, "?", local_import.shipper, local_import.description, containers,
                     local_import.gwt, local_import.bl_number, local_import.original_documents_date, local_import.vessel_name,
                     local_import.estimated_arrival, local_import.shipping_line.name, local_import.exemption_code_date, 
                     local_import.customs_entry_number, local_import.customs_entry_date, trucks]
    end
    p.use_shared_strings = true
    filePath = "#{Rails.root}/tmp/"
    fileName = "LocalOrder-#{@local_import.idf_date}.xlsx"
    p.serialize(filePath + fileName)

    attachments[fileName] = File.read(filePath + fileName)
    mail(to: emails, subject: "New Order Created")
    File.delete(filePath + fileName)
  end

  def customs_entry_email(local_import)
    @local_import = local_import
    @customer = local_import.customer
    emails = @customer.emails.to_s.split(",")
    mail(to: emails, subject: "Customs Entry Email")
  end

  def duty_paid_email(local_import)
    @local_import = local_import
    @customer = local_import.customer
    emails = @customer.emails.to_s.split(",")
    containers = "#{local_import.quantity} x #{local_import.equipment_type}"
    trucks = local_import.local_import_items.pluck(:truck).join(', ')
    offloading_dates = local_import.local_import_items.pluck(:offloading_date).join(', ')

    p = Axlsx::Package.new
    p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
      sheet.add_row ["OUR REF", "Customer Reference", "SHIPPER", "GOODS DESCRIPTION", "CONTAINERS", "GWT- KGS", "BL NO",
                     "DATE ORIGINAL DOCS RECEIVED", "VESSEL", "ETA", "SHIPPING LINE", "RECEIPT OF EXEMPTION", "CUSTOMS ENTRY NO.",
                     "CUSTOMS PAYMENT DATE", "ALLOCATED TRUCK(S)", "OFFLOADING DATE"]
      sheet.add_row [local_import.reference_number, "?", local_import.shipper, local_import.description, containers,
                     local_import.gwt, local_import.bl_number, local_import.original_documents_date, local_import.vessel_name,
                     local_import.estimated_arrival, local_import.shipping_line.name, local_import.exemption_code_date, 
                     local_import.customs_entry_number, local_import.customs_entry_date, trucks, offloading_dates]
    end
    p.use_shared_strings = true
    filePath = "#{Rails.root}/tmp/"
    fileName = "LocalOrder-DutyPaid-#{@local_import.idf_date}.xlsx"
    p.serialize(filePath + fileName)

    attachments[fileName] = File.read(filePath + fileName)
    mail(to: emails, subject: "Duty paid Email.")
    File.delete(filePath + fileName)
  end
end
