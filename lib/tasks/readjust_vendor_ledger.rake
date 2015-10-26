namespace :vendor_ledgers do
  desc "Recreate Vendor Ledgers for a vendor_id"
  task :recreate, [:vendor_id] => [:environment] do |t,args|
    vendor = Vendor.find(args.vendor_id)
    # Remove all legders for this customer
    VendorLedger.where(vendor: vendor).destroy_all

    #Add Payments
    vendor.debit_notes.each do |debit_note|
      debit_note_vendor_ledger = debit_note.create_vendor_ledger(vendor_id: debit_note.vendor_id, date: debit_note.bill.bill_date, 
                                                                 amount: debit_note.amount, currency: debit_note.bill.currency)
    end

    vendor.payments.each do |payment|
      payment_vendor_ledger = payment.create_vendor_ledger(amount: payment.amount, vendor: payment.vendor, 
                                                           date: payment.date_of_payment, currency: payment.currency)
    end

    vendor.bills.each do |bill|
      bill_vendor_ledger = bill.create_vendor_ledger(amount: bill.value, vendor_id: bill.vendor_id, date: bill.bill_date, currency: bill.try(:currency))
    end

  end

  desc "Recreate Ledgers for ALL vendors"
  task recreate_all: :environment do
    Vendor.all.each do |v|
      Rake::Task["vendor_ledgers:recreate"].invoke(v.id)
    end
  end
end
