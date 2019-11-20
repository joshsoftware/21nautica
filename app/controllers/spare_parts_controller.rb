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
