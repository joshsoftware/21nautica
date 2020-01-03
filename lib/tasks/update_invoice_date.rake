namespace :update_invoice_date do
  desc "Updating invoice date from status_date model "
  task update: :environment do
    invoices = Invoice.where(date:nil,invoiceable_type:'BillOfLading',previous_invoice_id:nil)
    invoices.each do|invoice|
      import_items = invoice.invoiceable.import.import_items.pluck(:id)
      date = StatusDate.where(import_item_id:import_items).pluck(:loaded_out_of_port).compact.min
      invoice.update_columns(date:date)
    end
  end
end
