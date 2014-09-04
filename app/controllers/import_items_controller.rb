class ImportItemsController < ApplicationController

  def index
    imports = Import.includes(:import_item).where(status: "awaiting_truck_allocation").select("id")
    @import_items = ImportItem.where(import_id: imports).where.not(status: "delivered")
    @transporters = TRANSPORTERS.inject({}) {|h, x| h[x] = x; h}
  end

  def update
    import_item = ImportItem.find(import_item_update_params[:id])
    attribute = import_item_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    attribute = import_item_update_params[:columnName].downcase.gsub('/', '_').gsub(' ','_').to_sym
    if import_item.update(attribute => import_item_update_params[:value]||import_item_update_params[:g_f_expiry])
      render text: import_item_update_params[:value]||import_item_update_params[:g_f_expiry]
    else
      render text: import_item.errors.full_messages
    end
  end

  def updateStatus
    @import_item = ImportItem.find(params[:id])
    initial_status = @import_item.status
       if !import_item_params[:truck_number].nil?
        if initial_status == "under_loading_process"
          @import_item.remarks = import_item_params[:remarks]
          status = import_item_params[:status].downcase.gsub(' ', '_')
          status != @import_item.status ? @import_item.send("#{status}!".to_sym) : @import_item.save
        end
       else
        @import_item.remarks = import_item_params[:remarks]
        status = import_item_params[:status].downcase.gsub(' ', '_')
        status != @import_item.status ? @import_item.send("#{status}!".to_sym) : @import_item.save
       end
  end

  def history
    @import_items = ImportItem.where(status: "delivered")
  end
  def empty_containers
    @import_items = ImportItem.where(status: "delivered")
  end
  private

  def import_item_params
    params.permit(:id)
    params.require(:import_item).permit(:truck_number, :status, :remarks)
  end

  def import_item_update_params
    params.permit(:id, :columnName, :value,:g_f_expiry)
  end
end
