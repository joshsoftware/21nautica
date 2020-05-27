# frozen_string_literal: true

class LocalImportsController < ApplicationController
  before_action :set_local_import, only: [:edit, :update, :edit_idf, :update_dates, :update_offloadings, :view_offloading_modal,
                                          :load_offloading_form, :update_offloadings, :update_dates_form, :view_modal]

  def index
    @local_imports = LocalImport.where(status: nil)
    @equipment_type = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
  end

  def operation_index
    @local_imports = LocalImport.where(status: :order_created)
    @equipment_type = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
  end

  def history_index
    @local_imports = LocalImport.where(status: :order_completed)
  end

  def new
    @local_import = LocalImport.new
    @local_import.build_bill_of_lading
    @customers = Customer.order(:name)
  end

  def edit
    @customers = Customer.order(:name)
  end

  def new_idf
    @local_import = LocalImport.new
    @local_import.build_bill_of_lading
    @customers = Customer.order(:name)
    render "new_idf"
  end

  def edit_idf
    @customers = Customer.order(:name)
    render "edit_idf"
  end

  def create
    @local_import = LocalImport.new(local_import_params)
    @local_import.exemption_code_needed = false if !params[:local_import][:exemption_code_needed]
    @local_import.kebs_exemption_code_needed = false if !params[:local_import][:kebs_exemption_code_needed]

    if @local_import.save
      if params[:local_import][:fpd] && params[:local_import][:bl_number]
        @local_import.update(quantity: @local_import.local_import_items.count, status: :order_created)
        create_bill_of_lading
      end
      flash[:notice] = I18n.t "local_import.create"
      redirect_to local_imports_path
    else
      flash[:alert] = @local_import.errors.full_messages.join(", ")
      @customers = Customer.all
      render "new"
    end
  end

  def update
    attributes = local_import_params
    if attributes[:fpd] && attributes[:bl_number]
      attributes[:exemption_code_needed] = false if !params[:local_import][:exemption_code_needed]
      attributes[:kebs_exemption_code_needed] = false if !params[:local_import][:kebs_exemption_code_needed]
    end
    if @local_import.update_attributes(attributes)
      if attributes[:fpd] && attributes[:bl_number]
        @local_import.update(quantity: @local_import.local_import_items.count, status: :order_created)
        create_bill_of_lading
      end
      flash[:notice] = I18n.t "local_import.update"
      redirect_to :local_imports
    else
      @customers = Customer.all
      render "edit"
    end
    @local_import.update(status: :order_completed) if check_order_completed
  end

  def update_dates
    if @local_import.update(local_import_params)
      flash[:notice] = I18n.t "local_import.update"
    else
      flash[:alert] = I18n.t "local_import.update_error" + @local_import.error.full_messages.join(', ') 
    end
    @local_import.update(status: :order_completed) if check_order_completed
    @local_imports = LocalImport.where(status: :order_created)
    @equipment_type = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
    render "operation_index"
  end

  def load_offloading_form; end
  def update_dates_form; end
  
  def update_offloadings
    items = params[:local_import][:local_import_items_attributes]
    items.keys.each do |key|
      li = LocalImportItem.find(items[key][:id])
      li.truck = items[key][:truck]
      li.offloading_date = items[key][:offloading_date]
      if li.save
        flash[:notice] = I18n.t "local_import_item.update"
      else
        flash[:alert] = I18n.t "local_import_item.error" + li.errors.full_messages.join(", ")
      end
    end
    @local_import.update(status: :order_completed) if check_order_completed
  end

  def view_modal
    @local_import = @local_import.attributes.slice("exemption_code_date", "kebs_exemption_code_date", "customs_entry_number", 
                      "customs_entry_date", "duty_payment_date", "sgr_move_date", "icd_arrival_date", "loaded_out_date")
  end

  def view_offloading_modal;  end

  private
  def set_local_import
    @local_import = LocalImport.find(params[:id])
  end

  def check_exemption_dates
    if @local_import.exemption_code_needed
      return false if !@local_import.exemption_code_date
    elsif @local_import.kebs_exemption_code_needed
      return false if !@local_import.kebs_exemption_code_date
    end
    true
  end

  def check_order_completed
    check_exemption_dates && @local_import.customs_entry_number.present? &&
    @local_import.customs_entry_date.present? && @local_import.duty_payment_date.present? &&
    @local_import.sgr_move_date.present? && @local_import.icd_arrival_date.present? &&
    @local_import.loaded_out_date.present? && check_all_items
  end

  def check_all_items
    @local_import.local_import_items.each do |item|
      return false unless item.container_number.present? && item.truck.present? && item.offloading_date.present?
    end
    true
  end

  def create_bill_of_lading
    bl = BillOfLading.new(bl_number: @local_import.bl_number)
    if bl.save
      @local_import.bill_of_lading = bl
    else
      @local_import.errors.messages.merge!(bl.errors.messages)
      false
    end
  end

  def local_import_params
    params.require(:local_import).permit(:bl_number, :description, :shipper, :equipment_type,
                                         :exemption_code_needed, :kebs_exemption_code_needed, :vessel_name,
                                         :estimated_arrival, :idf_number, :idf_date, :invoice_number,
                                         :customer_reference, :status, :customer_id, :bill_of_lading_id,
                                         :gwt, :fpd, :remark, :reference_number, :shipping_line_id,
                                         :reference_date, :quantity, :exemption_code_date,
                                         :kebs_exemption_code_date, :customs_entry_number,
                                         :customs_entry_date, :duty_payment_date, :sgr_move_date,
                                         :icd_arrival_date, :loaded_out_date,
                                         local_import_items_attributes: %i[container_number id _destroy])
  end
end
