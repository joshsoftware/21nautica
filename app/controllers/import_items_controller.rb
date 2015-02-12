class ImportItemsController < ApplicationController

  def index
    imports = Import.includes(:import_item).where(status: "ready_to_load").select("id")
    @import_items = ImportItem.where(import_id: imports).where.not(status: "delivered")
    @transporters = Vendor.pluck(:name).inject({}) {|h, x| h[x] = x; h}
  end

  def update
    import_item = ImportItem.find(import_item_update_params[:id])
    attribute = import_item_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    attribute = import_item_update_params[:columnName].downcase.gsub('/', '_').gsub(' ','_').to_sym
    if import_item.update(attribute => import_item_update_params[:value]||import_item_update_params[:g_f_expiry]||import_item_update_params[:close_date])
      render text: import_item_update_params[:value]||import_item_update_params[:g_f_expiry]||import_item_update_params[:close_date]
    else
      render text: import_item.errors.full_messages
    end
  end

  def updateContext
    @import_item = ImportItem.find(params[:id])
    after_delivery = params[:after_delivery]
    date = Date.today
    @import_item[:after_delivery_status] = after_delivery.humanize
    if(after_delivery == "export_reuse")
      @import_item[:context] = "Customer Name: " + import_item_params[:context]+" , " +date.strftime("%d-%m-%Y")
    elsif(after_delivery == "drop_off")
      @import_item[:context] = "Yard Name: " + import_item_params[:context] +" , " + date.strftime("%d-%m-%Y")
    else
      @import_item[:context] = "Truck Number: " + import_item_params[:context] +" , "+"Transporter: "+import_item_params[:transporter_name]+" , " +date.strftime("%d-%m-%Y")
    end
    @import_item.save
  end

  def updateStatus
    @import_item = ImportItem.find(params[:id])
    initial_status = @import_item.status
    if import_item_params[:transporter].nil?
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
  end

  def history
    respond_to do |format|
      format.html{}
      format.json{ render json: {data: ImportItem.where(status: "delivered") } }
    end
  end

  def empty_containers
    @import_items = ImportItem.where(:status => "delivered", :after_delivery_status => nil)
  end

  private

  def import_item_params
    params.permit(:id)
    params.require(:import_item).permit(:truck_number, :status, :remarks, :context, :transporter_name, :transporter)
  end

  def import_item_update_params
    params.permit(:id, :columnName, :value,:g_f_expiry,:close_date)
  end
end
