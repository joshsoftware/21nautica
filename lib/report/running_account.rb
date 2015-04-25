require 'csv'
module Report
  class RunningAccount

    def self.create(customer)
      outstanding = { less_30: 0, bw_30_60: 0, bw_60_90: 0, bw_90_120: 0, more_120: 0 }
      total = { less_30: 0, bw_30_60: 0, bw_60_90: 0, bw_90_120: 0, more_120: 0 }
      # Collect ledgers for the customer
      ledgers = customer.ledgers.order(date: :desc)
      
      CSV.generate do |f|
        f << ['Date', 'Type', 'Invoice No.', 'BL Number', 'Amount', 'Received']
        ledgers.each do |l|
          f << [ l.date.to_s, l.voucher_type, l.invoice_number, l.bl_number, l.amount, l.received ]
          sum(outstanding, total, l)
        end

        # Update outstanding and totals
        f << [ "", "" ]
        f << [ "", "Less than 30 days", "30-60 days", "60-90 days", "90-120 days", "more than 120 days" ]
        f << [ "Total", total[:less_30], total[:bw_30_60], total[:bw_60_90], total[:bw_90_120], total[:more_120] ]
        f << [ "Outstanding", outstanding[:less_30], outstanding[:bw_30_60], outstanding[:bw_60_90], outstanding[:bw_90_120], outstanding[:more_120] ]
      end
    end

    def self.create_all
      # create report for all customers.
    end

    def self.sum(outstanding, total, ledger)
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
	
      if ledger.voucher_type == "Invoice"
        total[key] += ledger.amount
        outstanding[key] += (ledger.amount - ledger.received)
      end
    end
  end
end
