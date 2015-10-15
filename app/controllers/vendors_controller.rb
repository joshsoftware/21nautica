class VendorsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_vendors_type, except: [:index]
  before_action :get_vendor_id, only: [:edit, :update]

  def index
    @vendors = Vendor.all
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
       redirect_to vendors_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @vendor.update(vendor_params)
      redirect_to vendors_path
    else
      render 'edit'
    end
  end

  private

  def get_vendor_id
    @vendor = Vendor.find(params[:id])
  end

  def get_vendors_type
    @vendor_type = ITEM_FOR.keys 
  end

  def vendor_params
    if params
      vendor_type = params[:vendor][:vendor_type] 
      vendor_type = vendor_type.reject(&:empty?).map { |vendor| vendor }.join(',')
      params[:vendor][:vendor_type] = vendor_type
    end
    params.require(:vendor).permit(:name, :vendor_type)
  end
end
