require 'csv'
namespace "21nautica" do
  desc 'dump invoices for vendor Tenya Logistics'
  task dump_invoices_tenya_logistics: :environment do
    CSV.open("#{Rails.root}/tmp/tenya_logistics_invoices.csv", 'wb') do |csv|
      vendor = Vendor.where(name: 'Tenya Logistics').first
      invoices = Bill.where(vendor_id: vendor.id).order(bill_date: :asc)
      headers = ['Vendor Name', 'Invoice No', 'Invoice Date', 'Haulage', 'Empty Return', 'Truck Detention', 'Local Shunting',
                 'ICD Charges', 'Other Charges', 'Ocean Freight', 'Container Demurrage', 'Port Charges', 'Shipping Line Charges', 
                 'Port Storage', 'VAT', 'Final Clearing', 'Others', 'Agency Fee', 'Border Clearing Expense']
      csv << headers
      invoices.each do |inv|
        charges_hash = {}
        CHARGES.values.flatten.uniq.each do |charge|
          amount = BillItem.where(charge_for: charge, vendor_id: vendor.id, bill_id: inv.id).sum(:line_amount)
          charges_hash[charge] = amount.to_f
        end
        csv << [inv.vendor.name, inv.bill_number, inv.bill_date, charges_hash['Haulage'], charges_hash['Empty Return'], 
                charges_hash['Truck Detention'], charges_hash['Local Shunting'], charges_hash['ICD Charges'], 
                charges_hash['Other Charges'], charges_hash['Ocean Freight'], charges_hash['Container Demurrage'], 
                charges_hash['Port Charges'], charges_hash['Shipping Line Charges'], charges_hash['Port Storage'],
                charges_hash['VAT'], charges_hash['Final Clearing'], charges_hash['Others'], charges_hash['Agency Fee'],
                charges_hash['Border Clearing Expense']]
      end
    end
  end

  desc 'dump invoices from 1.4.2015 to 31.3.2016'
  task dump_invoices_from_jan_to_mar: :environment do
    CSV.open("#{Rails.root}/tmp/invoices.csv", 'wb') do |csv|
      csv << ['Customer Name', 'Invoice Number', 'Invoice Date', 'BL Number/Container Number',
              'Quantity', 'Equipment Type', 'Document Number', 'Invoice Amount', 'Status']
      invoices = Invoice.includes(:customer).where(date: '1-4-2015'.to_date..'31-3-2016'.to_date).order(date: :asc)
      invoices.each do |inv|
        csv << [inv.customer.name, inv.number, inv.date, inv.bl_or_container_number, inv.total_containers,
                inv.equipment_type, inv.document_number, inv.amount, inv.status]
      end
    end
  end

  desc "Dump Invoices upto 30/6/2016"
  task dump_invoices: :environment do
    CSV.open("#{Rails.root}/invoices.csv", 'wb') do |csv|
      csv << ['Invoice Number', 'Invoice Date', 'Customer Name', 'Invoice Value']
      invoices = Invoice.includes(:customer).where("date <= ?",  '30-06-2016'.to_date).order(date: :asc)
      invoices.each do |inv|
        csv << [inv.number, inv.date, inv.customer.name, inv.amount] 
      end
    end
  end

  desc 'Customer Name : Total Invoice Value : Total Payments Received ( Upto 31st March and Upto 30th June 2016)'
  task dump_customer_invoices: :environment do |csv|
    CSV.open("#{Rails.root}/tmp/customers_invoices.csv", 'wb') do |csv|
      csv << ['Customer Name', 'Total Invoice Value', 'Total Payment Received(upto 31th Mar 2016)',
              'Total Payments Received(upto 30th June 2016)']
      customers = Customer.all
      customers.each do |customer|
        total_invoice_upto_mar = customer.invoices.where('date <= ?', '31-3-2016'.to_date).sum(:amount).round(2)
        total_invoice_upto_jun = customer.invoices.where(date: '1-4-2016'.to_date..'30-6-2016'.to_date).sum(:amount).round(2)
        csv << [customer.name, customer.invoices.sum(:amount).round(2), total_invoice_upto_mar, total_invoice_upto_jun]
      end
    end
  end

  desc 'Vendor Name : Total Invoice value : Total Payments Made (Upto 31st March and Upto 30th June 2016)'
  task dump_vendor_invoices: :environment do |csv|
    CSV.open("#{Rails.root}/tmp/vendors_invoices.csv", 'wb') do |csv|
      csv << ['Vendor Name', 'Total Invoice Value', 'Total Payments Paid(upto 31th Mar 2016)',
              'Total Payments Paid(upto 30th June 2016)']
      vendors = Vendor.all
      vendors.each do |vendor|
        total_invoice_upto_mar = vendor.bills.where('bill_date <= ?', '31-3-2016'.to_date).sum(:value).round(2)
        total_invoice_upto_jun = vendor.bills.where(bill_date: '1-4-2016'.to_date..'30-6-2016'.to_date).sum(:value).round(2)
        csv << [vendor.name, vendor.bills.sum(:value).round(2), total_invoice_upto_mar, total_invoice_upto_jun]
      end
    end
  end

  desc 'dump all Invoices upto 31/03/16, if any vendor invoice date is beyond 01/04/16 list of Vendor Name, number, value & Customer inv. number'
  task vendor_invoices_dump_31_march: :environment do |csv|
    invoices = Invoice.includes(:customer).where("date <= ?",  '31-03-2016'.to_date).order(date: :asc)
    CSV.open("#{Rails.root}/tmp/invoices_upto_march.csv", 'wb') do |csv|
      csv << ['Customer Name', 'Customer Invoice amount', 'Vendor Name', 'Vendor Invoice Date',
              'Vendor Invoice Amount', 'Vendor Invoice Number', 'Customer Invoice Number']
      invoices.each do |invoice|
        invoiceable = invoice.invoiceable   #BillOfLading OR Movement Object

        if invoice.invoiceable_type == 'BillOfLading'
          activity_id = invoice.invoiceable.import.id unless invoice.invoiceable.nil? || invoice.invoiceable.import.nil?
          item_type = 'Import'
        else
          activity_id = invoice.invoiceable.export_item.export_id  unless invoice.invoiceable.nil? || invoice.invoiceable.export_item.nil?
          item_type = 'Export'
        end

        inv_number = []
        if invoice.additional_invoices.present?
          inv_number << invoice.number
          inv_number << invoice.additional_invoices.pluck(:number)
        else
          inv_number << invoice.number
        end

        bill_items = BillItem.includes(:vendor, :bill).where('bill_date >= ? AND activity_id = ? AND item_type = ?', 
                                                             '1-4-2016'.to_date, activity_id, item_type).order(bill_date: :asc)
        bill_items.each do |bill_item|
          csv << [invoice.customer.name, invoice.amount, bill_item.vendor.name, bill_item.bill_date, bill_item.line_amount, 
                  bill_item.bill.bill_number, inv_number].flatten
        end
      end
    end
  end

  desc 'dump all Invoices upto 30/06/16, if any vendor invoice date is beyond 01/07/16 list of Vendor Name, number, value & Customer inv. number'
  task vendor_invoices_dump_30_june: :environment do |csv|
    invoices = Invoice.includes(:customer).where("date <= ?",  '30-06-2016'.to_date).order(date: :asc)
    CSV.open("#{Rails.root}/tmp/invoices_upto_june.csv", 'wb') do |csv|
      csv << ['Customer Name', 'Customer Invoice amount', 'Vendor Name', 'Vendor Invoice Date',
              'Vendor Invoice Amount', 'Vendor Invoice Number', 'Customer Invoice Number']
      invoices.each do |invoice|
        invoiceable = invoice.invoiceable   #BillOfLading OR Movement Object

        if invoice.invoiceable_type == 'BillOfLading'
          activity_id = invoice.invoiceable.import.id unless invoice.invoiceable.nil? || invoice.invoiceable.import.nil?
          item_type = 'Import'
        else
          activity_id = invoice.invoiceable.export_item.export_id  unless invoice.invoiceable.nil? || invoice.invoiceable.export_item.nil?
          item_type = 'Export'
        end

        inv_number = []
        if invoice.additional_invoices.present?
          inv_number << invoice.number
          inv_number << invoice.additional_invoices.pluck(:number)
        else
          inv_number << invoice.number
        end

        bill_items = BillItem.includes(:vendor, :bill).where('bill_date >= ? AND activity_id = ? AND item_type = ?',
                                                             '1-7-2016'.to_date, activity_id, item_type).order(bill_date: :asc)
        bill_items.each do |bill_item|
          csv << [invoice.customer.name, invoice.amount, bill_item.vendor.name, bill_item.bill_date, bill_item.line_amount, 
                  bill_item.bill.bill_number, inv_number].flatten
        end
      end
    end
  end
end

