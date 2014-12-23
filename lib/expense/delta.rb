module Expense
  class Delta
    def self.generate_report
      package, workbook = ReportHelper::add_worksheet
      add_import_expense_data(workbook)
      fetch_bol_export_audits(workbook)
      ReportHelper::serialize_package(package, "Delta")
    end

    def self.add_import_expense_data(workbook)
      sheet = workbook.sheet_by_name("Import Expenses")
      sheet.add_row ["BL Number", "Container Number", "Haulage-Name",
                     "Haulage-Amount", "Empty Name", "Empty Amount",
                     "Final Clearing Name", "Final Clearing Amount",
                     "Demurrage Name", "Demurrage Amount", "ICD name",
                     "ICD amount"]
      audits = Espinita::Audit.where(created_at: 1.day.ago..Time.now.utc, auditable_type: "ImportExpense")
      audits_hash = {}
      audits.each do |audit|
        import_item = audit.auditable.import_item.id
        category = audit.auditable.category
        audit.audited_changes.each do |key,value|
          ((audits_hash[import_item] ||= {}) [category + 
            "_" + key.to_s] ||= " ").concat("\n #{value.second.to_s}")
        end 
      end
      audits_hash.each do |key, value|
        import_item = ImportItem.where(id: key).first
        sheet.add_row [import_item.try(:bl_number), import_item.try(:container_number), 
          value["Haulage_name"], value["Haulage_amount"], value["Empty_name"], value["Empty_amount"], 
          value["Final Clearing_name"], value["Final Clearing_amount"], value["Demurrage_amount"], 
          value["Demurrage_name"], value["ICD_name"], value["ICD_amount"]], height: 30
      end
    end

    def self.fetch_bol_export_audits(workbook)
      audits = Espinita::Audit.where(created_at: 1.day.ago..Time.now.utc, 
        auditable_type: ["Movement", "BillOfLading"])
      audits_hash = {}
      audits.each do |audit|
        audit.audited_changes.each do |key,value|
          (((audits_hash[audit.auditable_type] ||= {}) [audit.auditable_id] ||= 
            {}) [key] ||= "").concat("\n #{value.second.to_s}")
        end 
      end
      add_export_data(workbook.sheet_by_name("Export"),audits_hash["Movement"])
      add_bl_payments_data(workbook.sheet_by_name("BL Payment"), audits_hash["BillOfLading"])
    end

    def self.add_export_data(sheet, data)
      sheet.add_row ["BL Number", "Container Number", "Transporter Name",
                     "Transporter Payment", "Clearing Agent Name",
                     "Clearing Agent Payment"]
      data.each do |key, value|
        movement = Movement.where(id: key).first
        sheet.add_row [movement.try(:bl_number), movement.try(:container_number), 
          value[:transporter_name], value[:transporter_payment], value[:clearing_agent], 
          value[:clearing_agent_payment]], height: 30
      end
    end

    def self.add_bl_payments_data(sheet, data)
      sheet.add_row ["BL Number", "Type", "Payment Ocean",
                     "Cheque Ocean", "Payment Clearing",
                     "Cheque Clearing"]
      data.each do |key, value|
        bol = BillOfLading.where(id: key).first
        sheet.add_row [bol.bl_number, bol.is_export_bl? ? "Export" : "Import", 
          value[:payment_ocean], value[:cheque_ocean], value[:payment_clearing], 
          value[:cheque_clearing]],height: 30
      end
    end
 
  end
end
