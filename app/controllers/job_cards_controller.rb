class JobCardsController < ApplicationController
  before_action :find_job_card, only: %i[edit update]
  before_action :get_repair_head, :get_trucks, only: %i[new edit]
  def index 
    @job_card = JobCard.all.includes(:created_by, :truck)
  end
  def show
   @job_card = JobCard.find_by(id:params[:id])
   @job_card_details = @job_card.job_card_details.all.includes(:repair_head).paginate(page: params[:page], per_page: 10)
  end
  def new
    @job_card = JobCard.new
    @job_card.job_card_details.build
    @repair_heads = RepairHead.all.map { | repair_head | [repair_head.name ,repair_head.id] }
    @trucks = Truck.all.map { | truck | [truck.reg_number, truck.id] }
  end

  def create
    @job_card = current_user.job_cards.new job_card_params
    if @job_card.save 
      flash[:notice] = "Job Card Details saved"
      redirect_to :job_cards
    else
      flash[:error] = "error"
      render 'new'
    end
  end

  def update
    if @job_card.update(update_params)
      flash[:notice] = "Job Card updated successfully"
      redirect_to :job_cards
    else
      flash[:error] = "Error "
      render 'edit'
    end
  end

  private

  def update_params
    params.require(:job_card).permit(:date, :number, :truck_id, job_card_details_attributes:[:id, :repair_head_id, :description, :_destroy] )
  end
  def job_card_params
    params.require(:job_card).permit(:date, :number, :truck_id, job_card_details_attributes:[:repair_head_id, :description])
  end

  def find_job_card
    @job_card = JobCard.find_by(id:params[:id])
  end
  def get_repair_head
    @repair_heads = RepairHead.all.map { | repair_head | [repair_head.name ,repair_head.id] }
  end
  def get_trucks
    @trucks = Truck.all.map { | truck | [truck.reg_number, truck.id] }  
  end
end
