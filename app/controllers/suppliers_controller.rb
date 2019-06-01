class SuppliersController < ApplicationController
  before_action :load_supplier, only: [:edit, :update]

  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      flash[:notice] = 'Supplier created Successfully'
    end
  end

  def update
    if @supplier.update(supplier_params)
      flash[:notice] = "Purchase order updated sucessfully"
    end
  end

  private

  def supplier_params
    params.require(:supplier).permit(:name)
  end

  def load_supplier
    @supplier = Supplier.find(params[:id])
  end
end