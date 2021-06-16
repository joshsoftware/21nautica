class LoseCargoImportsController < ApplicationController

  def index
    destination = params[:destination] || 'Kampala'
    @import_ids = ImportItem.where(status: REMOVE_ALLOWED_STATUSES).pluck(:import_id).uniq
    @imports = Import.ready_to_load.where(order_type: ORDER_TYPE.last).where("remaining_quantity > 0 OR id IN (?)", @import_ids).where(to: destination)
  end

  def create_item
    import_item = ImportItem.new(import_item_params)
    import = Import.find_by_id(import_item_params['import_id'])
    if(import_item_params['item_quantity'].to_i > import.remaining_quantity.to_i)
      flash[:error] = "Item quantity should not be greater than #{import.remaining_quantity.to_i}"
    elsif import_item.save!
      remaining_quantity = import.remaining_quantity - import_item.item_quantity
      import.update_attributes(remaining_quantity: remaining_quantity)
      flash[:notice] = "Item added Successfully"
    else
      flash[:error] = "Could not able to add the Item!"
    end
    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end

  def show
    @import = Import.find(params['id'])
    @import_items = @import.import_items
  end

  def destroy
    import_item = ImportItem.find_by_id(params['id'])
    import = import_item.import
    remaining_quantity = import.remaining_quantity + import_item.item_quantity
    if import_item.present? && import_item.destroy
      import.update_attributes(remaining_quantity: remaining_quantity)
      flash[:notice] = "Item removed Successfully"
    else
      flash[:error] = "Could not remove the Item!"
    end
    redirect_to lose_cargo_import_path(import)
  end
  private

  def import_item_params
    params.require(:import_item).permit(:container_number, :id, :_destroy, :equipment, :item_quantity, :import_id)
  end
end
