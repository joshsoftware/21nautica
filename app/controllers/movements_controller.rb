class MovementsController < ApplicationController

  def index
    @movements = Movement.where.not(status: "document_handed").order(:booking_number)
  end
  
  def history
    @movements = Movement.where(status: "document_handed").order(:booking_number)
  end

  # JS call.
  def create
    movement = Movement.new(movement_params)
    @export_item = ExportItem.find(params[:export_item_id])
    movement.shipping_seal = @export_item.export.shipping_line
    movement.movement_type = @export_item.export.export_type
    if movement.save
      @export_item = ExportItem.find(params[:export_item_id])
      @export_item.movement_id = movement.id
      @export_item.save
      flash[:notice] = 'Successfully added new Movement'
    else
      flash[:error] = 'Error while saving movement'
    end
    render 'new'
  end

  def new
    @movement=Movement.new
  end

  def movement_params
    params.permit(:export_item_id)
    params.require(:movement).permit(:booking_number, :truck_number, :vessel_targeted, :port_of_destination, :movement_type)
  end

end
