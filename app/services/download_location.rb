class DownloadLocation

  def process
    CSV.generate do |data|
      data << headers
      Truck.find_each do |truck|
        data << [truck.reg_number, truck.location]
      end
    end
  end

  def headers
    ['TRUCK NUMBER', 'LOCATION']
  end
end
