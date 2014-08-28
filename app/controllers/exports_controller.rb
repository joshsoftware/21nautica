class ExportsController < ApplicationController
  
  def index
    # Get only those export items that do not have a movement_id
    @export_items = ExportItem.includes(:export).where(movement_id: nil).group_by(&:export_id)
    @exports = Export.where(id: @export_items.keys)
    @movement=Movement.new

    if request.xhr?
      render json: @export_items.to_json
    end
  end

  def new
    @export = Export.new
    @customers = Customer.all
  end

  def create 
    @export = Export.new(export_params)
    @customers = Customer.all
    # Add as many containers as mentioned in the Order#quantity
    @export.quantity.times { @export.export_items.build }
    if @export.save
      redirect_to exports_path
    else
      render 'new'
    end
  end

  private
  def export_params
    params.require(:export).permit(:export_type, :equipment, :quantity, :shipping_line, :release_order_number, :customer_id)
  end
end