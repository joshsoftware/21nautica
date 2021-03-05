require 'csv'
class TrucksController < ApplicationController
  before_action :set_make_model, only: %i[edit new create update]
  def index
    @trucks = Truck.includes(current_import_item: [import: [:customer]]).all
  end

  def new
    @truck = Truck.new
  end

  def create
    @truck = Truck.new(trucks_params)
    if @truck.save
      flash[:notice] = "Truck created sucessfully"
      redirect_to trucks_path
    else
      flash[:alert] = @truck.errors.full_messages
      render 'new'
    end
  end

  def edit
    @truck = Truck.find(params[:id])
  end

  def update
    @truck = Truck.find(params[:id])
    if @truck.update(trucks_params)
      flash[:notice] = "Truck created sucessfully"
      redirect_to trucks_path
    else
      flash[:notice] = @truck.errors.full_messages
      render 'new'
    end
  end

  def load_truck_numbers
    trucks = Truck.free.pluck(:reg_number, :id)
    render json: trucks.to_json
  end

  def import_location
    render && return if request.get?
    CSV.read(params[:file].path, headers: true).each do |row|
      Truck.update_location(row['TRUCK NUMBER'], row[1])
    end
    flash[:notice] = "Imported Location sucessfully"
    redirect_to import_location_trucks_path
  end

  def download_location
    data = DownloadLocation.new.process
    send_data data, filename: "LocationDownload.csv", type: "text/csv"
  end

  def export_location
    month = params[:month]
    unless month.present?
      flash[:error] = 'Please select month'
      render import_location_trucks_path
      return
    end
    start_date = Date.strptime(month, '%m-%Y').beginning_of_month
    end_date = Date.strptime(month, '%m-%Y').end_of_month
    file_path = DownloadLocation.new(true, start_date, end_date).process
    File.open(file_path, 'r') do |f|
      send_data f.read, filename: "LocationExport.xlsx", type: 'application/xlsx'
    end
    File.delete(file_path) if file_path
  end

  private

  def trucks_params
    params.require(:truck).permit(:reg_number, :trailer_reg_number,
                                  :driver_name, :fuel_capacity,
                                  :make_model_id, :insurance_expiry,
                                  :insurance_premium_amt_yearly, :is_active)
  end

  def set_make_model
    @make_models = MakeModel.order(:name).map { |make_model| [make_model.name, make_model.id] }
  end
end
