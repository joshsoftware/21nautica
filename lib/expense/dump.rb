module Expense
  class Dump
    def self.generate_report
      ReportHelper::add_worksheet_and_data(Dump)
    end

    def self.add_import_expenses_data(sheet)
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

    def self.add_export_data(sheet)
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

    def self.add_bl_payment_data(sheet)
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
