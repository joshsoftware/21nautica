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

  def report
    return if request.get?
    report_search = params[:report]
    if (report_search[:report_field].blank? || report_search[:report_value].blank? || report_search[:report_type].blank? ||
      report_search[:start_date].blank? || report_search[:end_date].blank?)
      flash[:error] = 'Please filled required input fields'
      render && return
    end
    @field = report_search[:report_field]
    @value = report_search[:report_value]
    @start_date = report_search[:start_date].to_date
    @end_date = report_search[:end_date].to_date
    @results = report_search[:report_type] == 'LPO' ? search_by_purchase_order : search_by_req_sheet
  end

  def search_by_purchase_order
    purchase_orders = PurchaseOrder.where(date: @start_date..@end_date)
    purchase_orders = purchase_orders.where("#{@field}" => @value) if PurchaseOrder.column_names.include?(@field)
    if PurchaseOrderItem.column_names.include?(@field)
      PurchaseOrderItem.includes(:purchase_order).where(purchase_order_id: purchase_orders.pluck(:id), "#{@field}" => @value)
    else
      PurchaseOrderItem.includes(:purchase_order).where(purchase_order_id: purchase_orders.pluck(:id))
    end
  end

  def search_by_req_sheet
    req_sheets = ReqSheet.where(date: @start_date..@end_date)
    req_sheets = req_sheets.where("#{@field}" => @value) if ReqSheet.column_names.include?(@field)
    if ReqPart.column_names.include?(@field)
      ReqPart.includes(:req_sheet).where(req_sheet_id: req_sheets.pluck(:id), "#{@field}" => @value)
    else
      ReqPart.includes(:req_sheet).where(req_sheet_id: req_sheets.pluck(:id))
    end
  end

  private

  def load_reports_data
    @spare_parts = SparePart.pluck(:id, :product_name)
    @suppliers = Supplier.pluck(:id, :name)
    @trucks = Truck.pluck(:id, :reg_number)
  end
  
  def load_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def purchase_orders_params
    params.require(:purchase_order).permit(:number, :date, :supplier_id, :total_cost,
      purchase_order_items_attributes: [:id, :of_type, :truck_id, :spare_part_id, :part_make, :mechanic_id, :price, :quantity,
        :total_price, :_destroy]
    )
  end

end
