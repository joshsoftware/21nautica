class LoseCargoImportsController < ApplicationController

  def index
    destination = params[:destination] || 'Kampala'
    @imports = Import.ready_to_load.where("order_type=? AND remaining_weight > 0", ORDER_TYPE.last).where(to: destination)
  end

  def new
    @import = Import.new
    @import.build_bill_of_lading
    @customers = Customer.order(:name)
    @import.order_type = "Lose-Cargo"
  end

  def edit
    @import = Import.find(params['id'])
    @customers = Customer.order(:name)
  end

  def update
    @import = Import.find(params['id'])
    total_quantity = params["import"]["import_items_attributes"].map { |import_item| import_item[1]["item_quantity"].to_i}.sum
    if(total_quantity > @import.item_quantity)
      flash[:error] = I18n.t 'lose_cargo_import.item_quantity_error'
      @customers = Customer.all
      render 'edit'
      return
    end
    if import_update_params.keys.length > 1
      attribute = import_update_params[:columnName].downcase.gsub(' ', '_').to_sym
      if import.update(attribute => import_update_params[:value])
        render text: import_update_params[:value]
      else
        render text: import.errors.full_messages
      end
    else
      if import_params[:bl_number].present? && @import.bl_number != import_params[:bl_number]
        unless @import.bill_of_lading.update(bl_number: import_params[:bl_number])
          flash[:error] = @import.bill_of_lading.errors.full_messages.join(', ')
          @customers = Customer.all
          render 'edit'
          return
        end
      end
      if @import.update_attributes(import_params)
        weight = @import.item_quantity*@import.item_weight
        assigned_weight = @import.import_items.pluck(:item_quantity, :item_weight).map { |i| i.inject(:*)}.sum
        @import.update(quantity: @import.import_items.count, weight: weight, remaining_weight: weight - assigned_weight)
        flash[:notice] = I18n.t 'lose_cargo_import.update'
        redirect_to :lose_cargo_imports
      else
        @customers = Customer.all
        render 'edit'
      end
    end
  end

  private

  def import_params
    params.require(:import).permit(:quantity, :from, :to, :shipper,
                                   :bl_number, :estimate_arrival, :description,
                                   :customer_id, :rate_agreed, :weight,
                                   :work_order_number, :remarks, :status,
                                   :shipping_line_id,
                                   :bl_received_type, :consignee_name,
                                   :item_quantity, :item_weight, :order_type,
                                   import_items_attributes: %i[container_number id _destroy equipment item_weight item_quantity])
  end

  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival)
  end

end
