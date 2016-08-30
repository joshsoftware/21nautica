require 'csv'
namespace "21nautica" do
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
end

