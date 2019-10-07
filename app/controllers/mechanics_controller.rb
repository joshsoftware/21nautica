# Mechanic Controller
class MechanicsController < ApplicationController
  before_action :set_mechanic, only: %i[edit update]

  def index
    @mechanics = Mechanic.includes(:created_by).order(:name)
                         .paginate(page: params[:page], per_page: 10)
  end

  def new
    @mechanic = Mechanic.new
  end

  def create
    @mechanic = current_user.mechanics.new(mechanic_params)
    if @mechanic.save
      flash[:notice] = I18n.t 'mechanic.saved'
      redirect_to :mechanics
    else
      render 'new'
    end
  end

  def update
    if @mechanic.update(mechanic_params)
      flash[:notice] = I18n.t 'mechanic.update'
      redirect_to :mechanics
    else
      render 'edit'
    end
  end

  private

  def set_mechanic
    @mechanic = Mechanic.find_by(id: params[:id])
  end

  def mechanic_params
    params.require(:mechanic).permit(:id, :name, :designation, :salary, :date_of_employment)
  end
end
