namespace :ledgers do
  desc "Recreate Ledgers for a customer_id"
  task :recreate, [:customer_id] => [:environment] do |t,args|
    customer = Customer.find(args.customer_id)

    # Remove all legders for this customer
    Ledger.where(customer: customer).destroy_all
    # Add all invoice ledgers first
    customer.invoices.order(date: :asc).sent.each do |inv|
      inv.create_ledger(amount: inv.amount, customer: inv.customer, date: inv.date, received: 0)
      #p inv.inspect
      #inv.update_ledger
    end

    # Add all received ledgers
    customer.payments.each do |recv|
      recv.create_ledger(amount: recv.amount, customer: recv.customer, date: recv.date_of_payment)
      #p recv.inspect
      #recv.update_ledger
    end
  end

  desc "Recreate Ledgers for ALL customers"
  task recreate_all: :environment do
    Customer.all.each do |c|
      Rake::Task["ledgers:recreate"].invoke(c.id)
    end
  end
end
