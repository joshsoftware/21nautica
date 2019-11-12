class SparePartsController < ApplicationController
  before_action :find_spare_part, only: [:edit, :update]

  def index
    if params[:searchTerm].present?
      @spare_parts = SparePart.where(search_query)
    else
      @spare_parts = SparePart.all
    end
    respond_to do |format|
      format.html{}
      format.json { render json: @spare_parts.order(:product_name) }
    end
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
                    purchase_order_items.purchase_order_id, trucks.reg_number truck_name")
                    .joins(:truck, :purchase_order => [:supplier])
                    .where(:purchase_order_items => {spare_part_id: params[:spare_part_id] || [0]})
                    .order("purchase_order_items.created_at DESC")
      data = po_history.offset(params[:start]).limit(params[:length] || 10)
      json_data = {"data" => data, "recordsTotal" => po_history.count("purchase_order_items.id"), "recordsFiltered" => po_history.count("purchase_order_items.id") }
    elsif params[:history_type] == "req"
      if params[:truck].present?
        req_history = ReqPart.select("req_parts.created_at, req_parts.price, req_parts.quantity,
                      trucks.reg_number truck_name")
                      .joins(:req_sheet => [:truck])
                      .where(:req_parts => {spare_part_id: params[:spare_part_id] || [0]})
                      .where("req_parts.created_at >= ? ", Time.zone.now - 3.months)
                      .where("trucks.reg_number ILIKE ?", "%#{params[:truck]}%")
                      .order("req_parts.created_at DESC")
      else
        req_history = ReqPart.select("req_parts.created_at, req_parts.price, req_parts.quantity,
                       trucks.reg_number truck_name")
                      .joins(:req_sheet => [:truck])
                      .where(:req_parts => {spare_part_id: params[:spare_part_id] || [0]})
                      .where("req_parts.created_at >= ?", Time.zone.now - 3.months)
                      .order("req_parts.created_at DESC")
      end
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

  def search_query
    terms = params[:searchTerm].split(" ").map {|term| term.prepend("'%")+"%'"}
    terms = terms.join(",")
    query = "lower(product_name) ILIKE ALL(ARRAY[#{terms}])"
  end
end
