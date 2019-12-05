module Report
  class DailyPettyCashLedger
    def petty_cash_ledger
      package = Axlsx::Package.new
      workbook = package.workbook
      worksheet_name = "Petty Cash ledger #{Date.yesterday}"
      workbook.styles do |s|
        heading = s.add_style alignment: {horizontal: :center},
          b: true, sz: 13, bg_color: "00B0F0", wrap_text: true,
          :border => {:style => :thin, :color => "00"}
        center = s.add_style alignment: {vertical: :top, wrap_text: true },
          :border => {:style => :thin, :color => "00" }, sz: 10
        workbook.add_worksheet(name:worksheet_name) do|sheet|
          add_data(sheet,heading,center)
        end
      end
      package.use_shared_strings = true
      package.serialize("#{Rails.root}/tmp/Petty Cash Ledger_#{Date.yesterday}.xlsx")
    end 

    def add_data(sheet,heading,center)
      date = Date.yesterday
      @petty_cashes = PettyCash.of_account_type('Cash').includes(:truck,:expense_head,:created_by).where(date:date).order(:id)
      sheet.add_row ['Date','Expense Head','Truck Number', 'Amount','Balance','created by'], style: heading, height: 40
      @petty_cashes.each do|petty_cash|
        truck_number = petty_cash.truck_id.nil? ? "": petty_cash.truck.reg_number
        expense_head = petty_cash.expense_head.name
        date = petty_cash.date
        transaction_amount = petty_cash.transaction_amount
        available_amount = petty_cash.available_balance 
        created_by = petty_cash.created_by.name
        sheet.add_row [date,expense_head,truck_number,transaction_amount,available_amount,created_by]
      end
    
    end
  end
end
