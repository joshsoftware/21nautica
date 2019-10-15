class BreakdownReasonsController < ApplicationController
  before_action :set_breakdown_reason, only: %i[edit update]
  
  def index
    @breakdown_reasons = BreakdownReason.paginate(page: params[:page], per_page: 20)
  end

  def new
    @breakdown_reason = BreakdownReason.new
  end

  def create
    @breakdown_reason = BreakdownReason.new(breakdown_reason_params)
    if @breakdown_reason.save
      flash[:notice] = I18n.t 'breakdown_reason.saved'
      redirect_to :breakdown_reasons
    else
      render 'new'
    end
  end

  def update
    if @breakdown_reason.update(breakdown_reason_params)
      flash[:notice] = I18n.t 'breakdown_reason.update'
      redirect_to :breakdown_reasons
    else
      render 'edit'
    end
  end

  private

  def set_breakdown_reason
    @breakdown_reason = BreakdownReason.find_by(id: params[:id])
  end

  def breakdown_reason_params
    params.require(:breakdown_reason).permit(:id, :name)
  end
end
