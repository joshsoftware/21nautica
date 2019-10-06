# Transport Manger Cash Controller
class TransportMangerCashesController < ApplicationController
  before_action :set_trucks, only: %i[edit new create update]
  before_action :set_transport_cash, only: %i[edit update]

  def index
    @transport_manger_cashes = TransportMangerCash.where('created_at >= ? ', Date.today.beginning_of_month)
                                                  .order(:sr_number)
                                                  .includes(:import_item,
                                                            :import,
                                                            :created_by,
                                                            :truck)
  end

  def new
    @transport_manger_cash = TransportMangerCash.new
  end

  def create
    @transport_manger_cash = current_user.transport_manger_cashes.new(transport_manger_params)
    if @transport_manger_cash.save
      flash[:notice] = 'Transport Manger Cash saved successfully'
      redirect_to :transport_manger_cashes
    else
      render 'new'
    end
  end

  def update
    if @transport_manger_cash.update(transport_manger_params)
      flash[:notice] = 'Transport Manger Cash Update saved successfully'
      redirect_to :transport_manger_cashes
    else
      render 'edit'
    end
  end

  private

  def transport_manger_params
    params.require(:transport_manger_cash).permit(:id,
                                                  :truck_id,
                                                  :transaction_amount)
  end

  def set_trucks
    @trucks = ImportItem.where(status: 'truck_allocated')
                        .includes(:truck)
                        .map { |import_item| [import_item.truck.reg_number, import_item.truck.id] unless import_item.truck_id.nil? }.compact!
  end

  def set_transport_cash
    @transport_manger_cash = TransportMangerCash.find_by(id: params[:id])
  end
end
