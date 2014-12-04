module ReportHelper
  def ReportHelper.add_worksheet_and_data(class_type)
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    package = Axlsx::Package.new
    workbook = package.workbook
    ['Import Expenses', 'Export', 'BL Payment'].each do |name|
      workbook.add_worksheet(name: name) do |sheet|
        class_type.add_import_expenses_data(sheet) if name.eql?("Import Expenses")
        class_type.add_export_data(sheet) if name.eql?("Export")
        class_type.add_bl_payment_data(sheet) if name.eql?("BL Payment")
        sheet.sheet_view.pane do |pane|
          pane.state = :frozen
          pane.y_split = 1
          pane.x_split = 2
          pane.active_pane = :bottom_right
        end
      end
    end
    package.use_shared_strings = true
    package.serialize("#{Rails.root}/tmp/#{class_type.to_s.gsub("::","_")}_#{time}.xlsx")
  end
end