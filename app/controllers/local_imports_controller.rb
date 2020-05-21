# frozen_string_literal: true

class LocalImportsController < ApplicationController
  before_action :set_local_import, only: [:edit, :update, :edit_idf]

  def index
    @local_imports = LocalImport.all
    @equipment_type = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
    @all = true
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
    if @local_import.save
      @local_import.update(quantity: @local_import.local_import_items.count, status: :order_created) if params[:fpd]
      flash[:notice] = I18n.t "local_import.create"
      if is_ug_host?
        authority_pdf = authority_letter_draft
        authorisation_pdf = authorisation_letter_pdf
        # UserMailer.welcome_message_import(@local_import, authority_pdf, authorisation_pdf).deliver
      else
        # UserMailer.welcome_message_import(@local_import).deliver
      end
      redirect_to local_imports_path
    else
      flash[:alert] = @local_import.errors.full_messages.join(', ')
      @customers = Customer.all
      render "new"
    end
  end

  def update
    if @local_import.update_attributes(local_import_params)
      @local_import.update(quantity: @local_import.local_import_items.count, status: :order_created) if params[:fpd]
      flash[:notice] = I18n.t "local_import.update"
      redirect_to :local_imports
    else
      @customers = Customer.all
      render "edit"
    end
  end

  def operation_index
    @local_imports = LocalImport.where(status: :order_created)
    @equipment_type = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
    @all = false
    render "index"
  end

  def authorisation_letter_pdf
    # AUTHORISATION LETTER FOR WEC LINES
    if @local_import.is_wecline_shipping?
      generate_pdf_for_ug_host('authorisation_letter_for_weclines')
    else
      generate_pdf_for_ug_host('a_letter')
    end
  end

  def authority_letter_draft
    generate_pdf_for_ug_host('authority_letter_draft')
  end

  def generate_pdf_for_ug_host(filename)
    html = render_to_string(action: filename, layout: false)
    options = { margin_bottom: '1.2in', margin_top: '2.8in' }
    kit = PDFKit.new(html, options)
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/invoices.css.scss"
    pdf = kit.to_pdf
    kit.to_file("#{Rails.root}/tmp/#{@bl_number}_#{filename}.pdf")
  end

  private

  def set_local_import
    @local_import = LocalImport.find(params[:id])
  end

  def local_import_params
    params.require(:local_import).permit(:bl_number, :description, :shipper, :equipment_type,
                                   :exemption_code_needed, :kebs_exemption_code_needed, :vessel_name,
                                   :estimated_arrival, :idf_number, :idf_date, :invoice_number,
                                   :customer_reference, :status, :customer_id, :bill_of_lading_id,
                                   :gwt, :fpd, :remark, :reference_number, :shipping_line_id,
                                   :reference_date, :quantity,
                                   local_import_items_attributes: %i[container_number id _destroy])
  end
end

