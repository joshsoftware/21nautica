class ExportsController < ApplicationController

  def index
    @exports = Export.all.to_a
  end

  def new
    @export = Export.new
    @customers = Customer.all.to_a
  end

  def create 
    @export = Export.new(export_params)
    if @export.save
      redirect_to exports_path
    else
      render 'new'
    end
  end

  private

  def export_params
    params.require(:export).permit(:export_type, :equipment, :quantity, :shipping_line, :release_order_number)
  end

end
