class BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_the_bill_id, only: [:edit, :update]

  def index
    @bills = Bill.order(created_at: :desc)
  end

  def new
    @charges = []
    @item_for = []
    @bill = Bill.new
  end

  def create
    @bill = Bill.new(bills_params)
    if @bill.save && @bill.bill_items.any? 
      flash[:notice] = "Bill created sucessfully"
      redirect_to bills_path
    else
      #flash[:alert] = @bill.errors.full_messages 
      load_collection
      render 'new'
    end
  end

  def load_collection
    vendor = Vendor.find(@bill.vendor_id).vendor_type.split(',')
    @charges = []
    @item_for = []
    vendor.each do |v_type| 
      @charges << CHARGES[v_type]
      @item_for << ITEM_FOR[v_type]
    end
    @charges.flatten!
    @item_for.flatten!
  end

  def edit
    load_collection
  end

  def update
    if @bill.update(bills_params) && @bill.bill_items.any?
      redirect_to bills_path
    else
      load_collection
      #flash[:alert] = @bill.errors.full_messages 
      render 'edit'
    end
  end

  def validate_of_uniquness_format
    if params[:bill_id] == ''
      # validate only for new Record 
      invoice_date = Date.parse params[:invoice_date]
      validate = Bill.where(vendor_id: params[:vendor_id], bill_number: params[:invoice_no], bill_date: invoice_date).present?
    else
      # do nothing
    end
    render json: { validate: validate }
  end

  # Validate the Item Number 
  def validate_item_number
    result = nil
    case params[:item_type] 
    when 'Import'
      if params[:item_for] == 'bl'
        result = Import.where('lower(bl_number) = ?', params[:item_number].strip.downcase).first.try(:id) 
      else
        result = ImportItem.where('lower(container_number) = ? ', params[:item_number].strip.downcase).first.try(:import_id)
      end
    when 'Export'
      if params[:item_for] == 'bl'
        result = Movement.where('lower(bl_number) = ?', params[:item_number].strip.downcase).first.try(:export_item).try(:export).try(:id)
      else
        result = ExportItem.where('lower(container) = ?', params[:item_number].strip.downcase).first.try(:export).try(:id)
      end
    else
    end

    render json: { result: result }
  end

  def validate_debit_note_number
    if params[:debit_note_type] == 'container'
      result = ImportItem.where('lower(container_number) = ?', params[:debit_note_number].strip.downcase).present? ||
        ExportItem.where('lower(container) = ?', params[:debit_note_number].strip.downcase).present?
    else
      result = Import.where('lower(bl_number) = ?', params[:debit_note_number].strip.downcase).present? ||
        Movement.where('lower(bl_number) = ?', params[:debit_note_number].strip.downcase).present?
    end

    render json: { result: result }
  end

  private

  def get_the_bill_id
    @bill = Bill.find(params[:id])
  end

  def bills_params
    params.require(:bill).permit(:id, :vendor_id, :bill_number, :bill_date, :value, :created_by_id, :approved_by_id, :created_on, 
                                 :remark, :currency,
                                  bill_items_attributes: [:id, :vendor_id, :bill_id, :item_type, :item_for, :item_number, :charge_for,
                                                          :quantity, :rate, :line_amount, :activity_type, :activity_id, :_destroy],
                                  debit_notes_attributes: [:id, :vendor_id, :bill_id, :debit_note_for, :number, :reason, :amount, :_destroy]
                                )
  end

end
