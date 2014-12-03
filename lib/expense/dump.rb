module Expense
  class Dump
    def generate

      time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
      package = Axlsx::Package.new
      workbook = package.workbook

      ['Import Expenses', 'Export', 'BL Payment'].each do |name|
        workbook.add_worksheet(name: name) do |sheet|
          add_import_expenses_data(sheet) if name.eql?("Import Expenses")
          add_export_data(sheet) if name.eql?("Export")
          add_bl_payment_data(sheet) if name.eql?("BL Payment")
          sheet.sheet_view.pane do |pane|
            pane.state = :frozen
            pane.y_split = 1
            pane.x_split = 2
            pane.active_pane = :bottom_right
          end

        end
      end
      package.use_shared_strings = true
      package.serialize("#{Rails.root}/tmp/Expense_Dump_#{time}.xlsx")

    end

    def add_import_expenses_data(sheet)
      sheet.add_row ["BL Number", "Container Number", "Haulage-Name",
                     "Haulage-Amount", "Empty Name", "Empty Amount",
                     "Final Clearing Name", "Final Clearing Amount",
                     "Demurrage Name", "Demurrage Amount", "ICD name",
                     "ICD amount"]
      import_item = ImportItem.includes(:import_expenses)
      import_item.each do |item|
        haulage = item.import_expenses.where(category: "Haulage").first
        empty = item.import_expenses.where(category: "Empty").first
        final_clearing = item.import_expenses.where(category: "Final Clearing").first
        demurrage = item.import_expenses.where(category: "Demurrage").first
        icd = item.import_expenses.where(category: "ICD").first

        sheet.add_row [item.bl_number, item.container_number,
                       haulage.name, haulage.amount, empty.name,
                       empty.amount, final_clearing.name,
                       final_clearing.amount, demurrage.name,
                       demurrage.amount, icd.name, icd.amount]
      end
    end

    def add_export_data(sheet)
      sheet.add_row ["BL Number", "Container Number", "Transporter Name",
                     "Transporter Payment", "Clearing Agent Name",
                     "Clearing Agent Payment"]
      movements = Movement.all
      movements.each do |movement|
        sheet.add_row [movement.bl_number, movement.container_number,
                       movement.transporter_name, movement.transporter_payment,
                       movement.clearing_agent, movement.clearing_agent_payment]
      end

    end

    def add_bl_payment_data(sheet)
      sheet.add_row ["BL Number", "Type", "Payment Ocean",
                     "Cheque Ocean", "Payment Clearing",
                     "Cheque Clearing"]
      bills_of_lading = BillOfLading.all

      bills_of_lading.each do |bol|
        sheet.add_row [bol.bl_number,
          Import.where(bl_number: bol.bl_number).blank? ? "export" : "import",
          bol.payment_ocean, bol.cheque_ocean, bol.payment_clearing,
          bol.cheque_clearing]
      end
    end
  end

end
