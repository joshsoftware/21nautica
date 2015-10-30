module Report
  class CustomerAnalysis

    def calculate_margin(customer) 
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "#{customer.name}") do |sheet|
        add_data(sheet, customer)
      end
      package.use_shared_strings = true

      package.serialize("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}.xlsx")
    end

    def add_data(sheet, customer)
      sheet.add_row ['Date', 'BL Number', 'W/o Num', 'Quantity', 'EQ', 'AF', 'SLC', 'PC', 'PS', 'OF', 'CD', 'FC', 
                     'Haulage', 'ER', 'TDC', 'LS', 'ICD', 'Others','INV', 'Invoice Amount', 'Margins']
      invoices = customer.invoices

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
          charges         = get_charges(activity_id)
          inv             = invoice.number
          inv_amount      = invoice.amount 
          margins         = invoice.amount - ( charges['agency_fee'] + charges['shipping_line'] + charges['port_charges'] + 
                          charges['port_storage'] + charges['ocean_freight'] + charges['cont_demurrage'] + charges['final_clearing'] + 
                          charges['haulage'] + charges['empty_return'] + charges['truck_detention'] + charges['local_shunting'] +
                          charges['icd_charges'] + charges['others'] ) 
    
          sheet.add_row [date, bl_number, work_order_num, quantity, equipment_type, 
            charges['agency_fee'], charges['shipping_line'], charges['port_charges'], charges['port_storage'], charges['ocean_freight'],
            charges['cont_demurrage'], charges['final_clearing'], charges['haulage'], charges['empty_return'], charges['truck_detention'],
            charges['local_shunting'], charges['icd_charges'], charges['others'], inv, inv_amount, margins] 
        end
      end
      sheet
    end

    def get_charges(activity_id)
      charges = {}
      { 'agency_fee' => 'Agency Fee', 'shipping_line' => 'Shipping Line Charges', 'port_charges' => 'Port Charges', 
        'port_storage' => 'Port Storage', 'ocean_freight' =>'Ocean Freight', 'cont_demurrage' => 'Container Demurrage',
        'final_clearing'=> 'Final Clearing', 'haulage' => 'Haulage', 'empty_return' => 'Empty Return', 'truck_detention' => 'Truck Detention',
        'local_shunting' => 'Local Shunting', 'icd_charges' => 'ICD Charges', 'others' => 'Others' }.each do |k, value|

        charges[k] = BillItem.where(activity_id: activity_id, charge_for: value).sum(:line_amount)
      end
      charges
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
