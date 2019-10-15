# Transport Manger Cash Controller
class TransportManagerCashesController < ApplicationController
  before_action :set_trucks, only: %i[edit new create update]
  before_action :set_transport_cash, only: %i[edit update]

  def index
    @transport_manager_cashes = TransportManagerCash.where('created_at >= ? ', Date.today.beginning_of_month)
                                                  .order(:sr_number)
                                                  .includes(:import_item,
                                                            :import,
                                                            :created_by,
                                                            :truck)
    @available_balance = TransportManagerCash.last_balance
  end

  def new
    @transport_manager_cash = TransportManagerCash.new
  end

  def create
    @transport_manager_cash = current_user.transport_manager_cashes.new(transport_manger_params)
    if @transport_manager_cash.save
      flash[:notice] = 'Transport Manger Cash saved successfully'
      redirect_to :transport_manager_cashes
    else
      render 'new'
    end
  end

  def update
    if @transport_manager_cash.update(transport_manger_params)
      flash[:notice] = 'Transport Manger Cash Update saved successfully'
      redirect_to :transport_manager_cashes
    else
      render 'edit'
    end
  end

  private

  def transport_manger_params
    params.require(:transport_manager_cash).permit(:id,
                                                  :import_item_id,
                                                  :transaction_type,
                                                  :transaction_amount)
  end

  def set_trucks
    @trucks = ImportItem.includes(:truck)
                        .where.not(truck_id: nil)
                        .where(status: 'truck_allocated')
                        .map { |import_item| [import_item.truck.reg_number, import_item.id] }
  end

  def set_transport_cash
    @transport_manager_cash = TransportManagerCash.find_by(id: params[:id])
  end
end
