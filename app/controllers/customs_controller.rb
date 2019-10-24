# frozen_string_literal: true
 
class CustomsController < ApplicationController
  before_action :set_import, except: [:index, :update_column]
  def index
    destination = params[:destination] || 'Kampala'
    @imports = Import.not_ready_to_load.custom_entry_not_generated.where(to: destination)
    @equipment = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
  end

  def update
    params[:import][:entry_number]= nil if params[:import][:entry_number].empty?
    params[:import][:rotation_number]= nil if params[:import][:rotation_number].empty?
    @import.update(update_params)
  end

  def retainStatus
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

  def fetch_shipping_modal
    respond_to do |format|               
      format.js
    end        
  end   

  private

  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival, :is_date)
  end

  def update_params
    params.require(:import).permit(:entry_number, :rotation_number)
  end

  def set_import
    @import = Import.find(params[:id])
  end
end
