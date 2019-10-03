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
    @import.update(update_params)
  end

  def updateStatus
    @import = Import.find(params[:id])
    status = custom_params[:status].downcase.gsub(' ', '_')
    @import.remarks.create(desc: custom_params[:remarks], date: Date.today, category: "external") unless custom_params[:remarks].blank?
    if status != @import.status
      begin
        @import.send("#{status}!".to_sym)
      rescue
        @import.errors[:work_order_number] = "first enter file ref number or entry number"
        @errors = @import.errors.messages.values.flatten
      end
    else
      @import.save
    end
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
    params.require(:import).permit(:entry_number, :entry_type, :rotation_number)
  end

  def custom_params
    params.require(:import).permit(:remarks, :status)
  end

  def set_import
    @import = Import.find(params[:id])
  end
end
