module Report
  class CustomerAnalysis

    def calculate_margin(customers, month, selected_month, worksheet_name, ugx_amt) 
      package = Axlsx::Package.new
      workbook = package.workbook
       
      workbook.add_worksheet(name: "#{worksheet_name}") do |sheet|
        if customers == 'all'
          invoices = Invoice.where(date: selected_month.beginning_of_day..selected_month.end_of_month).order(date: :asc)
        else
          invoices = Invoice.where(customer_id: customers, date: selected_month.beginning_of_day..selected_month.end_of_month).order(date: :asc)
          invoices = Invoice.merge_additional_invoices(invoices)
        end
        add_data(sheet, invoices, ugx_amt)
      end
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/#{worksheet_name}#{selected_month.strftime("%Y")}.xlsx")
    end

    def add_data(sheet, invoices, ugx_amt)

      sheet.add_row ['Customer Name', 'Date', 'BL Number', 'W/o Num', 'Quantity', 'EQ', 'AF', 'SLC', 'PC', 'PS', 'OF', 'CD', 'FC', 
                     'Haulage', 'ER', 'TDC', 'LS', 'ICD', 'BCE','Other charges', 'Others', 'THC', 'Total Exp','INV', 'Invoice Amount', 'VD', 'Margins']

      invoices.each do |invoice|
        invoiceable = invoice.invoiceable   #BillOfLading OR Movement Object

        if invoice.invoiceable_type == 'BillOfLading'
          activity_id = invoice.invoiceable.import.id unless invoice.invoiceable.nil? || invoice.invoiceable.import.nil?
        else
          activity_id = invoice.invoiceable.export_item.export_id  unless invoice.invoiceable.nil? || invoice.invoiceable.export_item.nil?
        end
        bill_of_lading = BillOfLading.where(bl_number: invoiceable.bl_number).first unless invoiceable.nil?

        unless bill_of_lading.nil?
          date            = invoice.formatted_date
          bl_number       = bill_of_lading.bl_number + ' '
          work_order_num  = get_work_order_number(invoice)
          quantity        = bill_of_lading.quantity
          equipment_type  = bill_of_lading.equipment_type                             #equipment_type
          charges, total_exp = get_charges(activity_id, ugx_amt)
          if invoice.additional_invoices.present?
            inv           = invoice.number + ',' + invoice.additional_invoices.collect(&:number).join('')
            inv_amount    = invoice.additional_invoices.sum(:amount) + invoice.amount
          else
            inv_amount    = invoice.amount
            inv           = invoice.number
          end
          debit_note_amt  = get_debit_note_amt(invoice)
          margins         = (inv_amount - total_exp) + debit_note_amt
          customer_name   = invoice.customer.name
          
          sheet.add_row [customer_name, date, bl_number, work_order_num, quantity, equipment_type, 
            charges['Agency Fee'], charges['Shipping Line Charges'], charges['Port Charges'], charges['Port Storage'], charges['Ocean Freight'],
            charges['Container Demurrage'], charges['Final Clearing'], charges['Haulage'], charges['Empty Return'], charges['Truck Detention'],
            charges['Local Shunting'], charges['ICD Charges'], charges['Border Clearing Expense'], charges['Other charges'], 
            charges['Others'], charges['THC'], total_exp, inv, inv_amount, debit_note_amt, margins] 
        end
      end

      sheet
    end

    def get_debit_note_amt(invoice)
      invoiceable = invoice.invoiceable
      debit_note_sum = 0
      if invoice.invoiceable_type == 'BillOfLading'
        if invoiceable.import.nil?
          # Export TBL type
          export_item = invoiceable.movements.collect(&:export_item).collect(&:container)
          debit_note_sum += DebitNote.where(number: [invoiceable.bl_number, export_item]).sum(:amount)

        else
          debit_note_sum += DebitNote.where(number: [invoiceable.bl_number,
                                            invoiceable.import.import_items.collect(&:container_number)]).sum(:amount)
        end
      else
        debit_note_sum += DebitNote.where(number: [invoiceable.bl_number,
                                                invoiceable.export_item.container]).sum(:amount)
      end
      debit_note_sum
    end

    def get_charges(activity_id, ugx_amt)
      charges = {}
      total_exp = 0
      CHARGES.values.flatten.uniq.each do |charge|
        query = BillItem.includes(:bill).where(activity_id: activity_id, charge_for: charge)

        line_amount = 0
        query.each do |bill_item|
          bill_item.is_bill_invoice_ugx? ? line_amount += (bill_item.line_amount / ugx_amt) : line_amount += bill_item.line_amount
        end

        line_amount = (sprintf "%.2f", line_amount).to_f
        charges[charge] = line_amount 
        total_exp += line_amount
      end
      return charges, total_exp
    end

    def get_work_order_number(invoice)
      if invoice.invoiceable_type == 'BillOfLading'
        invoice.invoiceable.import.work_order_number || '' unless invoice.invoiceable.nil? || invoice.invoiceable.import.nil?
      else
        invoice.invoiceable.w_o_number || '' unless invoice.invoiceable.nil? 
      end
    end

  end
end
