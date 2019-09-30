class TransportMangerCashesController < ApplicationController
  before_action :set_trucks, only: %i[edit new]
  
  def index
  end

  def show
  end

  def new
    @transport_manger_cash = TransportMangerCash.new
  end

  def edit
  end

  def create
    @transport_manger = TransportMangerCash.new(transport_manger_params)
  end

  private

  def transport_manger_params
    params.require(:transport_manger_cash).permit(:id, :truck_id,)
  end

  def set_trucks
    @trucks = ImportItem.where(status:'truck_allocated').includes(:truck).map { |import_item| [import_item.truck.reg_number, import_item.id] unless import_item.truck_id.nil?  }.compact!
  end

end
