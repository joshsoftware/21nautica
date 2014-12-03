module Expense
  class Delta
    def self.generate_report

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
      package.serialize("#{Rails.root}/tmp/Expense_Delta_#{time}.xlsx")

    end

    def self.add_import_expenses_data(sheet)
      sheet.add_row ["BL Number", "Container Number", "Haulage-Name",
                     "Haulage-Amount", "Empty Name", "Empty Amount",
                     "Final Clearing Name", "Final Clearing Amount",
                     "Demurrage Name", "Demurrage Amount", "ICD name",
                     "ICD amount"]
      import_items = ImportItem.includes(:import_expenses)
      h = {}
      import_items.each do |import_item|
        max_height = 0
        import_item.import_expenses.each do |expense|
          audits = expense.audits.where("updated_at > ?",
                    (Time.now.utc - 1.days)).order(created_at: :asc).collect(&:audited_changes)
          audits.each do |audit|
            (h[expense.category + "_" + "name"] ||= []).push(audit[:name].second +
           " at: " + audit[:updated_at].second.to_s) if !audit[:name].blank?
            (h[expense.category + "_" + "amount"] ||= []).push(audit[:amount].second +
           " at: " + audit[:updated_at].second.to_s) if !audit[:amount].blank?
          end
        end
        h, max_height = format_hash_entries(h, max_height)
        sheet.add_row [import_item.bl_number, import_item.container_number,
          h["Haulage_name"], h["Haulage_amount"], h["Empty_name"],
          h["Empty_amount"], h["Final Clearing_name"], h["Final Clearing_amount"],
          h["Demurrage_name"], h["Demurrage_amount"], h["ICD_name"],
          h["ICD_amount"]], height: max_height
        h.clear
      end
      sheet.column_widths 15, 15, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20
    end

    def self.add_export_data(sheet)
      sheet.add_row ["BL Number", "Container Number", "Transporter Name",
                     "Transporter Payment", "Clearing Agent Name",
                     "Clearing Agent Payment"]
      movements = Movement.all
      max_height = 0

      movements.each do |movement|
        h, max_height = get_audits_data(movement, max_height,"transporter_name",
         "transporter_payment", "clearing_agent", "clearing_agent_payment")
        sheet.add_row [movement.bl_number, movement.container_number,
          h["transporter_name"],h["transporter_payment"], h["clearing_agent"],
          h["clearing_agent_payment"]], height: max_height, alignment: { wrap_text: true}
      end
      sheet.column_widths 15, 15, 30, 30, 30, 30

    end

    def self.add_bl_payment_data(sheet)
      sheet.add_row ["BL Number", "Type", "Payment Ocean",
                     "Cheque Ocean", "Payment Clearing",
                     "Cheque Clearing"]
      bills_of_lading = BillOfLading.all
      max_height = 0

      bills_of_lading.each do |bill_of_lading|
        h, max_height = get_audits_data(bill_of_lading, max_height,"payment_ocean",
         "cheque_ocean", "payment_clearing", "cheque_clearing")
        sheet.add_row [bill_of_lading.bl_number,
          Import.where(bl_number: bill_of_lading.bl_number).blank? ? "export" : "import",
          h["payment_ocean"],h["cheque_ocean"], h["payment_clearing"],
          h["cheque_clearing"]], height: max_height, alignment: { wrap_text: true}
      end
      sheet.column_widths 15, 15, 30, 30, 30, 30
    end

    def self.get_audits_data(data_entry, max_height, field1, field2, field3, field4)
      h = {}
      audits = data_entry.audits.where("updated_at > ?",
       (Time.now.utc - 1.days)).order(created_at: :asc).collect(&:audited_changes)
      audits.each do |audit|
        (h[field1] ||= []).push(audit[field1.to_sym].second +
           " at: " + audit[:updated_at].second.to_s) if !audit[field1.to_sym].blank?
        (h[field2] ||= []).push(audit[field2.to_sym].second +
           " at: " + audit[:updated_at].second.to_s) if !audit[field2.to_sym].blank?
        (h[field3] ||= []).push(audit[field3.to_sym].second +
           " at: " + audit[:updated_at].second.to_s) if !audit[field3.to_sym].blank?
        (h[field4] ||= []).push(audit[field4.to_sym].second +
           " at: " + audit[:updated_at].second.to_s) if !audit[field4.to_sym].blank?
      end
      h, max_height = format_hash_entries(h, max_height)
      return h, max_height
    end

    def self.format_hash_entries(h, max_height)
      h.replace( h.merge(h) {|key, value| value = value.join("\n")} )
      h.each_value{|v| max_height = v.length if v.length > max_height}
      max_height = (max_height * 0.7) if max_height > 50
      return h, max_height
    end

  end

end
