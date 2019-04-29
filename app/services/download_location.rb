class DownloadLocation

  def process
    @location_dates = LocationDate.includes(:truck).order(date: :asc)
    package = Axlsx::Package.new
    workbook = package.workbook.add_worksheet(name: 'LocationDownload') do |sheet|
      sheet.add_row headers
      Truck.includes(:location_dates).find_each do |truck|
        locations = truck.location_dates.order(date: :asc).pluck(:location)
        row = [truck.reg_number, ''] + locations
        sheet.add_row row 
      end
    end
    file_path = "#{Rails.root}/tmp/LocationDownload.xlsx"
    package.use_shared_strings = true
    package.serialize(file_path)
    return file_path
  end

  def headers
    mandatory_headers = ['Truck Number', '']
    dates = @location_dates.map { |d| d.date.strftime('%d/%m/%Y') }
    mandatory_headers + dates.uniq
  end
end
