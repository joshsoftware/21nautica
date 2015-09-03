class BillsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @bill = Bill.new
  end

  # load the Charges of Vendor 
  def load_vendor_charges 
    @vendor = {}
    vendor = Vendor.find_by(name: params[:vendor_name]).vendor_type.split(',')
    vendor.each do |type|
      @vendor.merge!(CHARGES.select { |k,v| k.include? type })
    end
  end

  # check whether its Container/BL
  def get_container
    @vendor = {}
    vendor = Vendor.find_by(name: params[:vendor_name]).vendor_type.split(',')
    vendor.each do |type|
      @vendor.merge!(ITEM_FOR.select { |k,v| k.include? type})
    end
  end

  # Get the Item Number 
  def get_number
    if params[:item_type] == 'Import'
      get_import_item_number(params[:vendor_id]) #******* Get Container Number
    else
      get_export_item_number(params[:vendor_id])
    end
  end

  private

  def get_export_item_number(vendor_id)
  end

  def get_import_item_number(vendor_id)
    @vendor_type = []
    vendor_type = Vendor.find(vendor_id).vendor_type.split(',')
    vendor_type.each do |type|
      if type == 'transporter'
        @vendor_type.concat(get_transporter_form_import_item(vendor_id))
      elsif type == 'clearing_agent'
        @vendor_type.concat(get_clearing_line_from_import(vendor_id))
      elsif type == 'shipping_line'
        @vendor_type.concat(get_shipping_line_from_import(vendor_id))
      else
        @vendor_type.concat(get_icd_from_import_item(vendor_id))
      end
    end
  end

  #******** Get transpoter **********
  def get_transporter_form_import_item(vendor_id)
    if vendor_id 
      item_number = ImportItem.where(vendor_id: vendor_id)
    else
      item_number = []
    end
    item_number
  end

  #********** Get clearing agent *********
  def get_clearing_line_from_import(vendor_id)
    if vendor_id 
      item_number = []
      imports = Import.where(clearing_agent_id: vendor_id)
      imports.each do |import|
        import.import_items.each do |import_item|
          item_number << import_item
        end
      end
    else
      item_number = []
    end
    item_number
  end

  #********** Get icd *********
  def get_icd_from_import_item(vendor_id)
    if vendor_id 
      item_number = ImportItem.where(vendor_id: vendor_id) 
    else
      item_number = []
    end
    item_number
  end

  #********** Get shipping_line *********
  def get_shipping_line_from_import(vendor_id)
    if vendor_id 
      item_number = []
      imports = Import.where(shipping_line_id: vendor_id)
      imports.each do |import|
        import.import_items.each do |import_item|
          item_number << import_item
        end
      end
    else
      item_number = []
    end
    item_number
  end

end
