# frozen_string_literal: true

class BreakdownManagementsController < ApplicationController

  before_action :set_breakdown_managemet, only: %i[edit update]
  before_action :set_mechanics, :set_trucks, :set_breakdown_reasons, only: %i[new edit]

  def index
    status_params = params[:status] if params[:status].present?
    @breakdown_managements = BreakdownManagement.order(date: :desc)
                                                .where(status: status_params || 'Open')
                                                .includes(:mechanic, :breakdown_reason, :truck)
  end

  def new
    @breakdown_management = BreakdownManagement.new
  end

  def create
    @breakdown_management = BreakdownManagement.new(breakdown_managemet_params)
    if @breakdown_management.save
      flash[:notice] = I18n.t 'breakdown_details.saved'
      redirect_to :breakdown_managements
    else
      render 'new'
    end
  end

  def update
    if @breakdown_management.update(breakdown_managemet_params)
      flash[:notice] = I18n.t 'breakdown_details.update'
      redirect_to :breakdown_managements
    else
      render 'edit'
    end
  end

  private

  def breakdown_managemet_params
    params.require(:breakdown_management).permit(:id, :breakdown_reason_id,
                                                 :truck_id, :date,
                                                 :location, :remark,
                                                 :sending_date, :mechanic_id,
                                                 :parts_required, :status)
  end

  def set_trucks
    @trucks = Truck.order(:reg_number)
                   .where.not(reg_number: 'Co-Loaded Truck')
                   .where.not(reg_number: '3rd Party Truck')
                   .map {|truck| [truck.reg_number, truck.id] }
  end

  def set_mechanics
    @mechanics = Mechanic.order(:name)
  end

  def set_breakdown_reasons
    @breakdown_reasons = BreakdownReason.order(:name)
  end

  def set_breakdown_managemet
    @breakdown_management = BreakdownManagement.find_by(id: params[:id])
  end
end
