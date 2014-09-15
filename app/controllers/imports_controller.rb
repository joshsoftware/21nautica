class ImportsController < ApplicationController

  def index
    @imports = Import.where.not(status: "ready_to_load")
    cust_array = Customer.all.select(:id , :name).to_a
    @customers = cust_array.inject({}) {|h,x| h[x.id] = x.name; h}
    @equipment = EQUIPMENT_TYPE.inject({}) {|h, x| h[x] = x; h}

  end

  def new
    @import = Import.new
    @customers = Customer.all
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      UserMailer.welcome_message_import(@import).deliver()
      redirect_to imports_path
    else
      @customers = Customer.all
      render 'new'
    end
  end

  def update
    import = Import.find(import_update_params[:id])
    attribute = import_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    if import.update(attribute => import_update_params[:value])
      render text: import_update_params[:value]
    else
      render text: import.errors.full_messages
    end
  end

  def updateStatus
    @import = Import.find(params[:id])
    @import.remarks = import_params[:remarks]
    status = import_params[:status].downcase.gsub(' ', '_')
    status != @import.status ? @import.send("#{status}!".to_sym) : @import.save
  end

  def retainStatus
    @import = Import.find(params[:id])
  end


  def history
  end

  private

  def import_params
    params.require(:import).permit(:equipment, :quantity, :from, :to,
                                   :bl_number, :estimate_arrival, :description,
                                   :shipping_line, :customer_id, :work_order_number,:remarks,:status,
                                    import_items_attributes:[:container_number])
  end


  def import_update_params
    params.permit(:id, :columnName, :value)
  end
end

