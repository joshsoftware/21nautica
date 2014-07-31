class MovementsController < ApplicationController

  def index
    @movements = Movement.where.not(status: "document_handed")
    @booking_number_list = @movements.select(:booking_number).uniq.order(booking_number: :asc)
    @movements_list = @booking_number_list.collect do |b_n| 
      @movements.where(booking_number: b_n.booking_number).select do |mov| 
        !mov.export_item.as_json.nil?
      end
    end
  end

  def create
  	 movement = Movement.new(movement_params)
     if movement.save
      Rails.logger.info params
      export_item = ExportItem.find(params[:export_item_id1])
      export_item.movement_id = movement.id
      export_item.save
      flash[:notice] = 'Successfully added new Movement'
    else
      flash[:error] = 'Error while saving movement'
    end
    @movement = Movement.all.to_a
    render 'new'
  end
  
  def new
  	@movement=Movement.new
  end
  
  def movement_params
    params.permit(:export_item_id,:export_item_id1)
    params.require(:movement).permit(:booking_number, :truck_number,:vessel_targeted,:point_of_destination,:movement_type)
  end

end