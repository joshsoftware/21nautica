class TrucksController < ApplicationController

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

  private

  def trucks_params
    params.require(:truck).permit(:reg_number)
  end
end
