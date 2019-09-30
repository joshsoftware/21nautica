class MechanicsController < ApplicationController
  before_action :set_mechanic, only: %i[edit update]

  def index
    @mechanics = Mechanic.order(id: :desc).paginate(page: params[:page], per_page: 10)
  end

  def new
    @mechanic = Mechanic.new
  end

  def create
    @mechanics = Mechanic.new(mechanic_params)
    if @mechanics.save
      flash[:notice] = 'mechanic saved successfully'
      redirect_to :mechanics
    else
      flash[:error] = 'Mechanic not saved'
      render 'new'
    end
  end

  def update
    if @mechanic.update(mechanic_params)
      flash[:notice] = 'Mechanic updated Successfully'
      redirect_to :mechanics
    else
      flash[:error] = 'Mechanic Not Updated Successfully'
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
