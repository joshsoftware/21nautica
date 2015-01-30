require 'csv'
namespace :invoices do
  desc "Task to add older invoices to system"
  task add_older: :environment do
    rows = CSV.read(ENV['filename'], headers: true)
    rows.each_with_index do |row, index|
      amount = row['Invoice Amount']
      invoice = Invoice.create(number: row['Invoice Number '], date: row['Invoice Date'], 
        document_number: row['Document Number'], amount: row['Invoice Amount'])
      customer = Customer.where(name: row['Customer Name']).first
      invoice.customer = customer
      bill_of_lading = BillOfLading.where(bl_number: row['BL Number']).first
      invoice.invoiceable = bill_of_lading unless bill_of_lading.blank?
      if invoice.save
        containers = invoice.total_containers
        particular = Particular.create(name: "Haulage", quantity: containers,
          rate: amount.to_i/containers, subtotal: amount)
        particular.invoice = invoice
        particular.save
        invoice.invoice_ready!
        invoice.invoice_sent!
      else
        p "row=> #{index+2} : #{invoice.errors.full_messages}"
      end
    end
    #File.delete(ENV['filename'])
  end
end
