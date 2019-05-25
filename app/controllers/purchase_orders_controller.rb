class PurchaseOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_purchase_order, only: [:edit, :update]

	def index
    @purchase_orders = PurchaseOrder.includes(:vendor).order('created_at DESC')
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

  private

  def load_purchase_order
  	@purchase_order = PurchaseOrder.find(params[:id])
  end

  def purchase_orders_params
    params.require(:purchase_order).permit(:number, :date, :vendor_id, :total_cost,
      purchase_order_items_attributes: [:id, :truck_id, :spare_part_id, :part_make, :mechanic_id, :price, :quantity,
        :total_price, :_destroy]
    )
  end

end
