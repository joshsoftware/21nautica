require 'csv'
module Report
  class RunningAccount

    def self.create(object, klass)
      outstanding = { less_30: 0, bw_30_60: 0, bw_60_90: 0, bw_90_120: 0, more_120: 0 }
      total = { less_30: 0, bw_30_60: 0, bw_60_90: 0, bw_90_120: 0, more_120: 0 }
      if klass == 'customer'
        customer = object
        # Collect ledgers for the customer
        ledgers = customer.ledgers.order(date: :desc) 
      else
        vendor = object
        ledgers = vendor.vendor_ledgers.order(date: :desc)
      end

      CSV.generate do |f|
        if klass == 'customer'
          f << ['Date', 'Type', 'Invoice No.', 'BL Number', 'Amount', 'Received']
          ledgers.each do |l|
            f << [ l.date.to_s, l.voucher_type, l.invoice_number, l.bl_number, l.amount, l.received ]
            sum(outstanding, total, l, 'customer')
          end
        else
          f << ['Date', 'Type', 'Invoice No.', 'Amount', 'Payment']
          #ledgers.each do |l|
          #  f << [ l.date.to_s, l.voucher_type, l.bill_number, l.amount, l.paid ]
          #  sum(outstanding, total, l, 'vendor')
          #end
        end

        # Update outstanding and totals
        f << [ "", "" ]
        f << [ "", "Less than 30 days", "30-60 days", "60-90 days", "90-120 days", "more than 120 days" ]
        f << [ "Total", total[:less_30], total[:bw_30_60], total[:bw_60_90], total[:bw_90_120], total[:more_120] ]
        f << [ "Outstanding", outstanding[:less_30], outstanding[:bw_30_60], outstanding[:bw_60_90], outstanding[:bw_90_120], outstanding[:more_120] ]
      end
    end

    def self.outstanding(klass)
      CSV.generate do |f|
        f << [ "Customer Name", "Total Invoice", "Total Payment", "Total", "( < 30 days)", "30-60 days", "60-90 days", "90-120 days", "( > 120 days)" ]
        Customer.all.each do |c|
          data = create(c, klass)
          str = CSV.parse(data)[-1][1..-1]
          total = str.inject(0) {|s, i| s + i.to_i }
          total_invoiced = c.ledgers.where(voucher_type: "Invoice").sum(:amount)
          total_received = c.ledgers.where(voucher_type: "Payment").sum(:amount)
          f << [ c.name, total_invoiced , total_received, total ] + str
        end
      end
    end

    def self.sum(outstanding, total, ledger, klass)
      case (ledger.date)
        when (Date.today - 30.days)..Date.today
          key = :less_30
        when (Date.today - 60.days)..(Date.today - 30.days)
          key = :bw_30_60
        when (Date.today - 90.days)..(Date.today - 60.days)
          key = :bw_60_90
        when (Date.today - 120.days)..(Date.today - 90.days)
          key = :bw_90_120
        else
          key = :more_120
        end
	
      if klass == 'customer'
        if ledger.voucher_type == "Invoice"
          total[key] += ledger.amount
          outstanding[key] += (ledger.amount - ledger.received)
        end
      else
        #Vendor
      end
    end
  end
end
