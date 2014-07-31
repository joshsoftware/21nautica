class MovementsController < ApplicationController

  def index
    @movements = Movement.where.not(status: "document_handed").group_by(&:booking_number)
  end

  def create
  	 movement = Movement.new(movement_params)
    if movement.save
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
    params.require(:movement).permit(:booking_number, :truck_number,:vessel_targeted,:point_of_destination,:movement_type)
  end

end