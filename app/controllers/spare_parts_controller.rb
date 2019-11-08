class SparePartsController < ApplicationController
  before_action :find_spare_part, only: [:edit, :update]

  def index
    @spare_parts = SparePart.all
  end

  def create
    @spare_part = SparePart.new(spare_part_params)
    if @spare_part.save
       redirect_to spare_parts_path
    else
      render 'new'
    end
  end

  def new
    @spare_part = SparePart.new
  end

  def edit
  end

  def update
    if @spare_part.update(spare_part_params)
      redirect_to spare_parts_path
    else
      render 'edit'
    end
  end

  def load_sub_categories
    return unless params[:spare_part_category_id]
    category = SparePartCategory.find(params[:spare_part_category_id])
    render json: category.spare_part_categories.pluck(:name, :id)
  end

  def history
    json_data = []
    if params[:history_type] == "po"
      po_history = PurchaseOrderItem.select("purchase_order_items.created_at,
                    purchase_order_items.spare_part_id, purchase_order_items.quantity,
                    purchase_order_items.price, suppliers.name supplier_name,
                    purchase_order_items.purchase_order_id")
                    .joins(:purchase_order => [:supplier])
                    .where("purchase_order_items.created_at > ? AND purchase_order_items.spare_part_id= ?", Time.zone.now - 3.months, params[:spare_part_id]).order(created_at: :desc)
      data = po_history.offset(params[:start]).limit(params[:length] || 10)
      json_data = {"data" => data, "recordsTotal" => po_history.count("purchase_order_items.id"), "recordsFiltered" => po_history.count("purchase_order_items.id") }
    elsif params[:history_type] == "req"
      req_history = ReqPart.select(:created_at, :price, :quantity)
                    .where("created_at >= ? AND req_parts.spare_part_id=?",
                    Time.zone.now - 3.months, params[:spare_part_id]).order(created_at: :desc)
      data = req_history.offset(params[:start]).limit(params[:length] || 10)
      json_data = {:data => data, "recordsTotal" => req_history.count("req_parts.id"), "recordsFiltered" => req_history.count("req_parts.id") }
    end
    
    respond_to do |format|
      format.html{}
      format.json { render json: json_data }
    end    
  end

  private

  def spare_part_params
    params.require(:spare_part).permit(:product_name, :description, :spare_part_category_id, :spare_part_sub_category_id)
  end

  def find_spare_part
    @spare_part = SparePart.find(params[:id]) 
  end
end
