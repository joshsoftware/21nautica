class SparePartsController < ApplicationController
  before_action :find_spare_part, only: [:edit, :update]

  def index
    if params[:searchTerm].present?
      @spare_parts = SparePart.where(parent_id:nil).where(search_query).includes(:spare_part_category,:spare_part_sub_category)
    else
      @spare_parts = SparePart.where(parent_id:nil).includes(:spare_part_category,:spare_part_sub_category)
    end
    respond_to do |format|
      format.html{}
      format.json { render json: @spare_parts.order(:product_name) }
    end
  end

  def create
    @spare_part = SparePart.new(spare_part_params)
    if request.xhr?
      if @spare_part.save 
        @spare_parts = SparePart.where(parent_id:nil).order(:product_name)
        @req_sheet=ReqSheet.new
      else
        @errors = spare_part.errors.messages.values.flatten
      end
      render 'new'
    else
      if @spare_part.save
        redirect_to spare_parts_path
      else
        render 'new'
      end
    end
  end

  def new
    @spare_part = SparePart.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def merge
    @spare_parts = SparePart.where(is_parent:nil,parent_id:nil).order(:product_name).map { |spare_part| [spare_part.product_name , spare_part.id]}
  end

  def undo_merge
    if params[:spare_parts].present?
      child_part_ids = params[:spare_parts].split(" ")[0]
      @spare_parts = SparePart.where(id:child_part_ids)
      parent_ids=@spare_parts.pluck(:parent_id).uniq
      if @spare_parts.update_all(parent_id:nil)
        @spare_parts.each do|spare_part|
          @purchase_order_items=PurchaseOrderItem.where(original_id:spare_part.id)
          @req_parts = ReqPart.where(original_id:spare_part.id)
          @spare_part_ledgers = SparePartLedger.where(original_id:spare_part.id)
          @purchase_order_items.update_all(original_id:nil,spare_part_id:spare_part.id) if @purchase_order_items
          @req_parts.update_all(original_id:nil,spare_part_id:spare_part.id) if @req_parts
          @spare_part_ledgers.update_all(original_id:nil,spare_part_id:spare_part.id) if @spare_part_ledgers
        end
      end
      parent_ids.each do|id|
        child_spare=SparePart.where(parent_id:id)
        if child_spare.empty?
          parent_spare = SparePart.where(id:id)[0].update_attribute(:is_parent,nil)
        end
      end
      unmerged_spare_ids = parent_ids + params[:spare_parts]
      unmerged_spare_ids.each do |u_id|
        SparePartLedger.adjust_balance(u_id)
      end
      flash[:notice] = "Parts successfully Unmerged"
      redirect_to action: "undo_merge"
    else
      @spare_parts =SparePart.where.not(parent_id:nil).order(:product_name).pluck(:product_name,:id)
    end
  end

  def merge_content
    if params[:parent_spare] || params[:spare_part]
      if params[:parent_spare].eql?("New Spare")
        @spare_part = SparePart.new(spare_part_params)
        child_part_ids = params[:spare_parts].split(' ')
        if @spare_part.save
          parent_spare_id = @spare_part.id
          @spare_part.update_attribute(:is_parent, true)
          @child_parts = SparePart.where(id:child_part_ids)
          if @child_parts.update_all(parent_id:parent_spare_id)
            @child_parts.each do|child_part|
              child_part.purchase_order_items.update_all(spare_part_id:parent_spare_id, original_id:child_part.id) if child_part.purchase_order_items
              child_part.req_parts.update_all(spare_part_id:parent_spare_id, original_id:child_part.id) if child_part.req_parts
            end
          end
        end
      else
        parent_spare_id = params[:parent_spare]
        child_spare_ids = params[:spare_parts].remove(parent_spare_id).split(' ')
        @parent_spare = SparePart.where(id:parent_spare_id)[0]
        @parent_spare.update_attribute(:is_parent,true)
        @child_parts = SparePart.where(id:child_spare_ids)
        if @child_parts.update_all(parent_id:parent_spare_id)
          @child_parts.each do|child_part|
            child_part.purchase_order_items.update_all(spare_part_id:parent_spare_id, original_id:child_part.id) if child_part.purchase_order_items
            child_part.req_parts.update_all(spare_part_id:parent_spare_id, original_id:child_part.id) if child_part.req_parts
            child_part.spare_part_ledgers.update_all(spare_part_id:parent_spare_id,original_id:child_part.id) if child_part.spare_part_ledgers
          end
        end
      end
      SparePartLedger.adjust_balance(parent_spare_id)
      flash[:notice] ="spare parts merged successfully"
      redirect_to :merge_spare_parts
    else
      @spare_parts = SparePart.where(id: params[:spare_parts]) if params[:spare_parts].present?
      @spare_part = SparePart.new
      @parent_spares=SparePart.where(is_parent:true).order(:product_name).pluck(:product_name,:id)
    end
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
                    .where("purchase_order_items.created_at >= ?",Time.zone.now - 3.months)
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

  def search
    terms = params[:searchTerm].split(" ").map {|term| term.prepend("'%")+"%'"}
    terms = terms.join(",")
    query = "lower(product_name) ILIKE ALL(ARRAY[#{terms}])"
    @spare_parts = SparePart.where(parent_id:nil).where(query)
    render json: @spare_parts.pluck(:product_name, :id)
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
