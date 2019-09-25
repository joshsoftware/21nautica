class RepairHeadsController < ApplicationController
  before_action :get_repair_head, only: %i[edit update]
  def index
    @repair_heads = RepairHead.order(:name).paginate(page: params[:page], per_page: 20)
  end

  def new
    @repair_head = RepairHead.new
  end

  
  def create
    @repair_head = RepairHead.new(repair_head_params)
    if @repair_head.save
      flash[:notice] = I18n.t 'repair_head.success'
      redirect_to :repair_heads
    else
      render 'new'
    end
  end

  def update
    if @repair_head.update_attributes(repair_head_update_params)
      flash[:notice] = I18n.t 'repair_head.update'
      redirect_to :repair_heads
    else
      render 'edit'
    end
  end

  private

  def repair_head_params
    params.require(:repair_head).permit(:name)
  end

  def get_repair_head
    @repair_head = RepairHead.find_by(id: params[:id])
  end

  def repair_head_update_params
    params.require(:repair_head).permit(:name, :is_active)
  end
end
