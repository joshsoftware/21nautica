# frozen_string_literal: true
 
class ShippingsController < ApplicationController
  before_action :set_import, except: [:index, :update_column]
  def index
    destination = params[:destination] || 'Kampala'
    @imports = Import.not_ready_to_load.shipping_dates_not_present.where(to: destination)
    @equipment = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
  end
  
  def update_column
    import = Import.find(import_update_params[:id])
    attribute = import_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    value = if import_update_params[:is_date] == "true" && import_update_params[:value] == "true"
              Date.today
            else
              nil
            end
    if import.update(attribute => value)
      render text: import_update_params[:value]
    else
      render text: import.errors.full_messages
    end
  end

  def update
    # @import = Import.find(params[:id])
    @import.update(shipping_params)
  end

  def retainStatus
    # @import = Import.find(params[:id])
  end

  def late_document_mail
    # @import = Import.find(params[:id])
    UserMailer.late_document_mail(@import).deliver()
  end

  private

  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival, :is_date)
  end

  def update_params
    params.require(:import).permit(:return_location, :gf_return_date)
  end

  def shipping_params
    shipping_params = {}
    if params[:import][:return_location].present? && params[:import][:gf_return_date].present?
      shipping_params = shipping_params.merge({do_received_at: Date.today, return_location: params[:import][:return_location], gf_return_date: params[:import][:gf_return_date]})
    end
    shipping_params
  end

  def set_import
    @import = Import.find(params[:id])
  end
end
