class ImportItemsController < ApplicationController

  def index
  	imports = Import.includes(:import_item).where(status: "awaiting_truck_allocation").select("id")
    @import_items = ImportItem.where(import_id: imports).where.not(status: "delivered")
  end

  def update
    import_item = ImportItem.find(import_item_update_params[:id])
    attribute = import_item_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    if import_item.update(attribute => import_item_update_params[:value])
      render text: import_item_update_params[:value]
    else
      render text: import_item.errors.full_messages
    end
  end

  def updateStatus
    @import_item = ImportItem.find(params[:id])
    @import_item.truck_number = import_item_params[:truck_number]
    status = import_item_params[:status].downcase.gsub(' ', '_')
    status != @import_item.status ? @import_item.send("#{status}!".to_sym) : @import_item.save
  end

  private

  def import_item_params
    params.permit(:id)
    params.require(:import_item).permit(:truck_number, :status)
  end

  def import_item_update_params
    params.permit(:id, :columnName, :value)
  end
end
