class PurchaseOrdersController < ApplicationController
  before_action :load_purchase_order, only: [:edit, :update]
  before_action :load_reports_data, only: [:report]

  def index
    @purchase_orders = PurchaseOrder.includes(:supplier).order('created_at DESC')
  end

  def new
    @purchase_order = PurchaseOrder.new
  end

  def create
    @purchase_order = PurchaseOrder.new(purchase_orders_params)
    if @purchase_order.save
      flash[:notice] = "Purchase Order sucessfully"
      redirect_to purchase_orders_path
    else
      render 'new'
    end
  end

  def update
    if @purchase_order.update(purchase_orders_params)
      flash[:notice] = "Purchase order updated sucessfully"
      redirect_to purchase_orders_path 
    else
      render 'edit'
    end
  end

  def update_inv_number
    purchase_order = PurchaseOrder.find(params[:id])
    if purchase_order.update(inv_number: purchase_order_column_update[:value])
      render text: purchase_order_column_update[:value]
    else
      render text: purchase_order.errors.full_messages
    end
  end

  def report
    return if request.get?
    report_search = params[:report]
    if (report_search[:report_field].blank? || report_search[:report_value].blank? || report_search[:report_type].blank? ||
      report_search[:start_date].blank? || report_search[:end_date].blank?)
      flash[:error] = 'Please filled required input fields'
      render && return
    end
    @field = report_search[:report_field]
    @value = get_search_value(report_search)
    @start_date = report_search[:start_date].to_date
    @end_date = report_search[:end_date].to_date
    @results = report_search[:report_type] == 'LPO' ? search_by_purchase_order : search_by_req_sheet
    @total = @results.map{|result| result.try(:quantity).to_i*result.try(:price).to_f}.sum
  end

  def get_search_value(report_search)
    if report_search[:report_value] == 'ALL'
      if @field == 'supplier_id'
        @suppliers.map { |row| row[0] }
      elsif @field == 'truck_id'
        @trucks.map { |row| row[0] }
      else
        @spare_parts.map { |row| row[0] }
      end
    else
      report_search[:report_value]
    end
  end

  def search_by_purchase_order
    purchase_orders = PurchaseOrder.where(date: @start_date..@end_date)
    purchase_orders = purchase_orders.where("#{@field}" => @value) if PurchaseOrder.column_names.include?(@field)
    if PurchaseOrderItem.column_names.include?(@field)
      PurchaseOrderItem.includes(:truck,:spare_part,purchase_order:[:supplier]).where(purchase_order_id: purchase_orders.pluck(:id), "#{@field}" => @value)
    else
      PurchaseOrderItem.includes(:truck,:spare_part,purchase_order:[:supplier]).where(purchase_order_id: purchase_orders.pluck(:id))
    end
  end

  def search_by_req_sheet
    req_sheets = ReqSheet.where(date: @start_date..@end_date)
    req_sheets = req_sheets.where("#{@field}" => @value) if ReqSheet.column_names.include?(@field)
    if ReqPart.column_names.include?(@field)
      ReqPart.includes(:spare_part, req_sheet:[:truck]).where(req_sheet_id: req_sheets.pluck(:id), "#{@field}" => @value)
    else
      ReqPart.includes(:spare_part, req_sheet:[:truck]).where(req_sheet_id: req_sheets.pluck(:id))
    end
  end

  private

  def load_reports_data
    @spare_parts = SparePart.order(:product_name).where(parent_id:nil).pluck(:id, :product_name)
    @suppliers = Supplier.order(:name).pluck(:id, :name)
    @trucks = Truck.order(:reg_number).pluck(:id, :reg_number)
  end
  
  def load_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def purchase_orders_params
    params.require(:purchase_order).permit(:number, :date, :supplier_id, :total_cost, :inv_date, :inv_number,
      purchase_order_items_attributes: [:id, :of_type, :truck_id, :spare_part_id, :part_make, :mechanic_id, :price, :quantity,
        :total_price, :_destroy]
    )
  end

  def purchase_order_column_update
    params.permit(:id, :columnName, :value)
  end

end
