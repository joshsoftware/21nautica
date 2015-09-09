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
    p params
    p params[:vendor_id]
    p params[:invoice_no]
    validate = Bill.where(vendor_id: params[:vendor_id], bill_number: params[:invoice_no]).present?
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


  # Get the Item Number 
  def get_number
    if params[:item_type] == 'Import'
      get_import_item_number(params[:vendor_id], params[:item_for]) #******* Get Container Number && params[:item_for] = 'container' || 'bl'
    else
      get_export_item_number(params[:vendor_id])
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

  def get_import_item_number(vendor_id, item_for)
    @vendor_type = []
    vendor_type = Vendor.find(vendor_id).vendor_type.split(',')
    vendor_type.each do |type|
      if type == 'transporter'
        @vendor_type.concat(get_transporter_from_import_item(vendor_id, item_for))
      elsif type == 'clearing_agent'
        @vendor_type.concat(get_clearing_line_from_import(vendor_id, item_for))
      elsif type == 'shipping_line'
        @vendor_type.concat(get_shipping_line_from_import(vendor_id, item_for))
      else
        @vendor_type.concat(get_icd_from_import_item(vendor_id, item_for))
      end
    end
  end

  #******** Get transpoter **********
  def get_transporter_from_import_item(vendor_id, item_for)
    item_number = []
    if item_for == 'container' 
      item_number = ImportItem.where(vendor_id: vendor_id).collect(&:container_number)
    else
      import_items =  ImportItem.where(vendor_id: vendor_id) 
      import_items.each do |import_item|
        item_number << import_item.import
      end
      item_number.collect(&:bl_number)
    end
    item_number
  end

  #********** Get clearing agent *********
  def get_clearing_line_from_import(vendor_id, item_for)
    item_number = []
    if item_for == 'container' 
      imports = Import.where(clearing_agent_id: vendor_id)
      imports.each do |import|
        item_number << import.import_item.collect(&:container_number)
      end
    else
      item_number = Import.where(clearing_agent_id: vendor_id).collect(&:bl_number)
    end
    item_number
  end

  #********** Get icd *********
  def get_icd_from_import_item(vendor_id, item_for)
    item_number = []
    if item_for == 'container' #vendor_id 
      item_number = ImportItem.where(icd_id: vendor_id).collect(&:container_number) 
    else
      import_items = ImportItem.where(icd_id: vendor_id)
      import_items.each do |import_item|
        item_number << import_item.import
      end
      item_number.collect(&:bl_number)
    end
    item_number
  end

  #********** Get shipping_line *********
  def get_shipping_line_from_import(vendor_id, item_for)
    item_number = []
    if item_for == 'container' #vendor_id 
      item_number = []
      imports = Import.where(shipping_line_id: vendor_id)
      imports.each do |import|
        item_number << import.import_items.collect(&:container_number)
      end
    else
      item_number = Import.where(shipping_line_id: vendor_id).collect(&:bl_number)
    end
    item_number
  end

end
