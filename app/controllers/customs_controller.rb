# frozen_string_literal: true
 
class CustomsController < ApplicationController
  before_action :set_import, except: [:index, :update_column]
  def index
    destination = params[:destination] || 'Kampala'
    @imports = Import.not_ready_to_load.custom_entry_not_generated.where(to: destination)
    @equipment = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
  end
  
  def update_column
    import = Import.find(import_update_params[:id])
    attribute = import_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    value = import_update_params[:value]
    if import.update(attribute => value)
      render text: import_update_params[:value]
    else
      render text: import.errors.full_messages
    end
  end

  def update
    @import.update(update_params)
  end

  def retainStatus
    # @import = Import.find(params[:id])
  end

  def late_document_mail
    UserMailer.late_document_mail(@import).deliver()
  end

  private

  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival, :is_date)
  end

  def update_params
    params.require(:import).permit(:entry_number, :entry_type)
  end

  def custom_params
    custom_parameters = {}
    if params[:import][:return_location].present? && params[:import][:gf_return_date].present?
      custom_parameters = custom_parameters.merge({do_received_at: Date.today, return_location: params[:import][:return_location], gf_return_date: params[:import][:gf_return_date]})
    end
    custom_parameters
  end

  def set_import
    @import = Import.find(params[:id])
  end
end
