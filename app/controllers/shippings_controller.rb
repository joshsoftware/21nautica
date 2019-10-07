# frozen_string_literal: true
 
class ShippingsController < ApplicationController
  include ApplicationHelper
  before_action :set_import, except: [:index, :update_column]
  def index
    destination = params[:destination] || 'Kampala'
    @imports = Import.not_ready_to_load.shipping_dates_not_present.where(to: destination)
    @equipment = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
  end

  def update
    if @import.update(shipping_params)
      check_late_bl_received
    end
  end

  def update_column
    import = Import.find(import_update_params[:id])
    attribute = import_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    if import.update(attribute => import_update_params[:value])
      render text: import_update_params[:value]
    else
      render text: import.errors.full_messages
    end
  end

  def retainStatus
    @date_divs = shipping_date_divs(@import)
  end

  def fetch_shipping_modal
    respond_to do |format|               
      format.js
    end        
  end

  private

  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival, :is_date)
  end

  def shipping_params
    params.require(:import).permit(:return_location, :gf_return_date, :do_received_at,
                                   :bl_received_at, :charges_received_at, :charges_paid_at,
                                   :pl_received_at)
  end

  def set_import
    @import = Import.find(params[:id])
  end

  def check_late_bl_received
    @import.reload
    if params[:import][:late_submission] == "true" && @import.bl_received_at && @import.estimate_arrival && @import.bl_received_at > @import.estimate_arrival
      UserMailer.late_bl_received_mail(@import).deliver()
    end
  end
end
