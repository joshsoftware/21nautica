class BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_the_bill_id, only: [:edit, :update]

  def index
    @bills = Bill.order(created_at: :desc)
  end

  def new
    @bill = Bill.new
    @bill.bill_items.build
  end

  def create
    @bill = Bill.new(bills_params)
    if @bill.save
      redirect_to bills_path
    else
      render 'new'
    end
  end

  def edit
   vendor = Vendor.find @bill.vendor_id 
   @charges = CHARGES[vendor.vendor_type]
   @item_for = ITEM_FOR[vendor.vendor_type]
  end

  def update
    if @bill.update(bills_params)
      redirect_to bills_path
    else
      render 'edit'
    end
  end

  def validate_of_uniquness_format
    invoice_date = Date.parse params[:invoice_date]
    validate = Bill.where(vendor_id: params[:vendor_id], bill_number: params[:invoice_no], bill_date: invoice_date).present?
    render json: { validate: validate }
  end

  # Validate the Item Number 
  def validate_item_number
    case params[:item_type] 
    when 'Import'
      if params[:item_for] == 'bl'
        result = Import.where(clearing_agent_id: params[:vendor_id], bl_number: params[:item_number].strip).present? || 
          Import.where(shipping_line_id: params[:vendor_id], bl_number: params[:item_number].strip).present?
         #'get bl numbers from Import for clearing agent and shipping agent using vendor id'
      else
        result = ImportItem.where(vendor_id: params[:vendor_id], container_number: params[:item_number]).present? || 
          ImportItem.where(icd_id: params[:vendor_id], container_number: params[:item_number]).present?
        #'get container numbers from Impot_item for vendor id and icd id using vendor id'
      end
    when 'Export'
      if params[:item_for] == 'bl'
        #bill_of_lading = BillOfLading.find_by bl_number: params[:item_number]
        #result = (Movement.where(vendor_id: params[:vendor_id], bill_of_lading_id: bill_of_lading.id).uniq.present? if bill_of_lading)|| false 
        #'get uniq(bl) numbers from movement for  using vendor id'
      else
        #'get container numbers from Impot_item for vendor using vendor id'
      end
    else
    end

    render json: { result: result }
  end

  # load the Charges of Vendor 
  def load_vendor_charges() 
    @vendor = {}
    vendor = Vendor.find(params[:vendor_id]).vendor_type.split(',')
    vendor.each do |type|
      @vendor.merge!(CHARGES.select { |k,v| k.include? type })
    end
  end

  private

  def get_the_bill_id
    @bill = Bill.find(params[:id])
  end

  def bills_params
    params.require(:bill).permit(:vendor_id, :bill_number, :bill_date, :value, :created_by_id, :approved_by_id, :created_on, :remark,
                                  bill_items_attributes: [:id, :vendor_id, :bill_id, :item_type, :item_for, :item_number, :charge_for,
                                                          :quantity, :rate, :line_amount, :activity_type, :activity_id, :_destroy] 
                                )
  end

end
