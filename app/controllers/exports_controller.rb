class ExportsController < ApplicationController
  
  def index
    # Get only those export items that do not have a movement_id
    @export_items = ExportItem.includes(:export).where(movement_id: nil).group_by(&:export_id)
    @exports = Export.where(id: @export_items.keys)
    @movement=Movement.new
    cust_array = Customer.all.select(:id , :name).to_a
    @customers = cust_array.inject({}) {|h,x| h[x.id] = x.name; h}
    @equipment = EQUIPMENT_TYPE.inject({}) {|h, x| h[x] = x; h}   
    @transporters = Vendor.transporters.pluck(:name)
    if request.xhr?
      render json: @export_items.to_json
    end
  end

  def update
    export = Export.find(export_update_params[:id])
    attribute = export_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    if export.update(attribute => export_update_params[:value])
      render text: export_update_params[:value]
    else
      render text: export.errors.full_messages
    end  
  end

  def new
    @export = Export.new
    @customers = Customer.order(:name)
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

  def export_update_params
    params.permit(:id, :columnName, :value)
  end
end