class MovementsController < ApplicationController
  
  def index
  	@movements = Movement.where.not(status: "document_handed")
  	@booking_number_list = @movements.select(:booking_number).uniq.order(booking_number: :asc)
  	@movements_list = @booking_number_list.collect do |b_n| 
  		@movements.where(booking_number: b_n.booking_number).select do |mov| 
  			!mov.export_item.as_json.empty?
  		end
  	end

  end

  def new
  end

  def create
  end
end
