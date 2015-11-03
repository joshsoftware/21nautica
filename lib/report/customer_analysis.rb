module Report
  class CustomerAnalysis

    def calculate_margin(customer, invoices, month) 
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "#{customer.name}(#{month}) ") do |sheet|
        add_data(sheet, customer, invoices)
      end
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/margin_analysis_#{customer.name.tr(" ", "_")}.xlsx")
    end

    def add_data(sheet, customer, invoices)

      sheet.add_row ['Date', 'BL Number', 'W/o Num', 'Quantity', 'EQ', 'AF', 'SLC', 'PC', 'PS', 'OF', 'CD', 'FC', 
                     'Haulage', 'ER', 'TDC', 'LS', 'ICD', 'BCE','Others', 'Total Exp','INV', 'Invoice Amount', 'Margins']
      #invoices = customer.invoices

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
          bl_number       = bill_of_lading.bl_number
          work_order_num  = get_work_order_number(invoice)
          quantity        = bill_of_lading.quantity
          equipment_type  = bill_of_lading.equipment_type                             #equipment_type
          charges, total_exp = get_charges(activity_id)
          inv             = invoice.number
          inv_amount      = invoice.amount 
          margins         = invoice.amount - total_exp 
    
          sheet.add_row [date, bl_number, work_order_num, quantity, equipment_type, 
            charges['Agency Fee'], charges['Shipping Line Charges'], charges['Port Charges'], charges['Port Storage'], charges['Ocean Freight'],
            charges['Container Demurrage'], charges['Final Clearing'], charges['Haulage'], charges['Empty Return'], charges['Truck Detention'],
            charges['Local Shunting'], charges['ICD Charges'], charges['Border Clearing Expense'], charges['Other charges'], total_exp, inv, inv_amount, margins] 
        end
      end
      sheet
    end

    def get_charges(activity_id)
      charges = {}
      total_exp = 0
      CHARGES.values.flatten.uniq.each do |charge|
        line_amount = BillItem.where(activity_id: activity_id, charge_for: charge).sum(:line_amount)
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
