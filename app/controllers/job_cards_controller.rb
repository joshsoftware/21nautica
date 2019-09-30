# Job Card Details controller
class JobCardsController < ApplicationController
  before_action :set_job_card, only: %i[show edit update]
  before_action :set_repair_heads, :set_trucks, only: %i[new edit]

  def index
    @job_card = JobCard.order(id: :desc).includes(:created_by, :truck)
                       .paginate(page: params[:page], per_page: 10)
  end

  def show
    @job_card_details = @job_card.job_card_details.includes(:repair_head)
  end

  def new
    @job_card = JobCard.new
    @job_card.job_card_details.build
  end

  def create
    @job_card = current_user.job_cards.build(job_card_params)
    if @job_card.save
      flash[:notice] = I18n.t 'job_card.success'
      redirect_to :job_cards
    else
      render 'new'
    end
  end

  def update
    if @job_card.update(update_params)
      flash[:notice] = I18n.t 'job_card.update'
      redirect_to :job_cards
    else
      render 'edit'
    end
  end

  private

  def update_params
    params.require(:job_card).permit(:number, :truck_id,
                                     job_card_details_attributes:
                                      %i[id repair_head_id
                                         description _destroy])
  end

  def job_card_params
    params.require(:job_card).permit(:number, :truck_id,
                                     job_card_details_attributes:
                                      %i[repair_head_id description])
  end

  def set_job_card
    @job_card = JobCard.find_by(id: params[:id])
  end

  def set_repair_heads
    @repair_heads = RepairHead.all.map { |repair_head| [repair_head.name, repair_head.id] }
  end

  def set_trucks
    @trucks = Truck.all.map { |truck| [truck.reg_number, truck.id] }
  end
end
