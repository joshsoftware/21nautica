class ReqSheetsController < ApplicationController

  def index
    @req_sheets = ReqSheet.all
  end

  def new
    @req_sheet = ReqSheet.new
  end

  def create
    @req_sheet = ReqSheet.new(req_sheets_params)
    if @req_sheet.save
      flash[:notice] = "Req created sucessfully"
      redirect_to req_sheets_path 
    else
      render 'new'
    end
  end

  def edit
    @req_sheet = ReqSheet.find(params[:id])
  end

  def update
    @req_sheet = ReqSheet.find(params[:id])
    if @req_sheet.update(req_sheets_params)
      flash[:notice] = "Req updated sucessfully"
      redirect_to req_sheets_path 
    else
      render 'edit'
    end
  end

  def load_spare_part
    return unless params[:spare_part_id]
    spare_part = SparePart.find params[:spare_part_id]
    render json: spare_part.to_json
  end

  def check_truck_type
    return unless params[:truck_id]
    truck = Truck.find params[:truck_id]
    render json: truck.is_truck?
  end

  private

  def req_sheets_params
    params.require(:req_sheet).permit(:ref_number, :date, :truck_id, :km, :value, req_parts_attributes: [:id, :spare_part_id, :description,
                                                                                                         :mechanic_id, :price, :quantity,
                                                                                                         :total_cost, :_destroy] 
                                     )
  end

end
