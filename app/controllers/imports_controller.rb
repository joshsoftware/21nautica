class ImportsController < ApplicationController

  def new
    @import = Import.new
    @customers = Customer.all
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      redirect_to exports_path
    else
      render 'new'
    end
  end

  private
  def import_params
    params.require(:import).permit(:equipment, :quantity, :from, :to,
                                   :bl_number, :estimate_arrival, :description,
                                   :shipping_line, :customer_id)
  end


	def history
	end
end

