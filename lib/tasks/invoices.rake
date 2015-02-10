require 'csv'
namespace :invoices do
  desc "Task to add older invoices to system"
  task add_older: :environment do
    rows = CSV.read(ENV['filename'], headers: true)
    rows.each_with_index do |row, index|
      amount = row['Invoice Amount']
      customer = Customer.where(name: row['Customer Name']).first
      invoice = Invoice.create_with(date: row['Invoice Date'],
        document_number: row['Document Number'], amount: row['Invoice Amount'],
        customer: customer).find_or_create_by(number: row['Invoice Number '])
      if invoice.save
        bill_of_lading = BillOfLading.where(bl_number: row['BL Number']).first
        bill_of_lading.blank? ? (invoice.legacy_bl = row['BL Number']) : (invoice.invoiceable = bill_of_lading)
        containers = invoice.total_containers
        particular = Particular.create(name: "Haulage", quantity: containers,
          rate: amount.to_i/containers, subtotal: amount)
        particular.invoice = invoice
        particular.save
        invoice.invoice_ready! unless (invoice.sent? || invoice.ready?)
        invoice.invoice_sent! unless invoice.sent?
      else
        p "row=> #{index+2} : #{invoice.errors.full_messages}"
      end
    end
    #File.delete(ENV['filename'])
  end
end
