class DownloadLocation

  def initialize(generate_xlsx = false, start_date = Date.today, end_date = Date.today)
    @generate_xlsx = generate_xlsx
    @start_date = start_date
    @end_date = end_date
  end

  def process
    if @generate_xlsx
      @location_dates = LocationDate.where(date: @start_date..@end_date).order('date ASC')
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "Location") do |sheet|
        sheet.add_row export_headers
        add_data(sheet)
        package.use_shared_strings = true
      end
      file_path = "#{Rails.root}/tmp/LocationExport.xlsx"
      package.serialize file_path
      return file_path
    else
      CSV.generate do |data|
        data << headers
        Truck.find_each do |truck|
          status = 'Free'
          customer = nil
          if truck.current_import_item_id
            customer = truck.current_import_item.import.try(:customer).try(:name) if truck.current_import_item.import
            status = truck.current_import_item.status
          end
          data << [truck.reg_number, truck.location, status, customer]
        end
      end
    end
  end

  def headers
    ['TRUCK NUMBER', 'LOCATION', 'STATUS', 'CUSTOMER NAME']
  end

  def export_headers
    dates = @location_dates.pluck(:date)
    dates = dates.collect { |d| d.strftime('%d/%m/%Y') }
    ['TRUCK NUMBER'] + dates.uniq
  end

  def add_data(sheet)
    Truck.includes(:location_dates).each do |truck|
      locations = truck.location_dates.where(date: @start_date..@end_date).order('date ASC')
      sheet.add_row [truck.reg_number] + locations.pluck(:location)
    end
  end
end
