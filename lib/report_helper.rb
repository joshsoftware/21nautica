module ReportHelper
  def ReportHelper.add_worksheet
    package = Axlsx::Package.new
    workbook = package.workbook
    ['Import Expenses', 'Export', 'BL Payment'].each do |name|
      workbook.add_worksheet(name: name)
    end
    return package, workbook
  end

  def ReportHelper.serialize_package(package,type)
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    package.use_shared_strings = true
    package.serialize("#{Rails.root}/tmp/Expense_#{type}_#{time}.xlsx")
  end
  
end