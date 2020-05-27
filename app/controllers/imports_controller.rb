# frozen_string_literal: true
 
class ImportsController < ApplicationController
  def index
    destination = params[:destination] || 'Kampala'
    @imports = Import.not_ready_to_load.custom_shipping_dates_not_present.where(to: destination)
    @equipment = EQUIPMENT_TYPE.inject({}) { |h, x| h[x] = x; h }
  end

  def new
    @import = Import.new
    @import.build_bill_of_lading
    @customers = Customer.order(:name)
  end

  def edit
    @import = Import.find(params['id'])
    @customers = Customer.order(:name)
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      if is_ug_host?
        @bl_number = @import.bl_number
        authority_pdf = authority_letter_draft
        authorisation_pdf = authorisation_letter_pdf
        UserMailer.welcome_message_import(@import, authority_pdf, authorisation_pdf).deliver
      else
        UserMailer.welcome_message_import(@import).deliver()
      end
      redirect_to imports_path
    else
      @customers = Customer.all
      render 'new'
    end
  end

  def authorisation_letter_pdf
    # AUTHORISATION LETTER FOR WEC LINES
    if @import.is_wecline_shipping?
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
  
  def update
    @import = Import.find(params['id'])
    if import_update_params.keys.length > 1
      attribute = import_update_params[:columnName].downcase.gsub(' ', '_').to_sym
      if import.update(attribute => import_update_params[:value])
        render text: import_update_params[:value]
      else
        render text: import.errors.full_messages
      end
    else
      if @import.update_attributes(import_params)
        @import.update(quantity: @import.import_items.count)
        flash[:notice] = I18n.t 'import.update'
        redirect_to :imports
      else
        @customers = Customer.all
        render 'edit'
      end
    end
  end

  # def updateStatus not using right now
  #   @import = Import.find(params[:id])
  #   status = import_params[:status].downcase.gsub(' ', '_')
  #   @import.remarks.create(desc: import_params[:remarks], date: Date.today, category: "external") unless import_params[:remarks].blank?
  #   if status != @import.status
  #     begin
  #       @import.send("#{status}!".to_sym)
  #     rescue
  #       @import.errors[:work_order_number] = "first enter file ref number or entry number"
  #       @errors = @import.errors.messages.values.flatten
  #     end
  #   else
  #     @import.save
  #   end
  # end

  def retainStatus
    @import = Import.find(params[:id])
  end

  private

  def import_params
    params.require(:import).permit(:equipment, :quantity, :from, :to, :shipper,
                                   :bl_number, :estimate_arrival, :description,
                                   :customer_id, :rate_agreed, :weight,
                                   :work_order_number, :remarks, :status,
                                   :shipping_line_id,
                                   :bl_received_type, :consignee_name,
                                   import_items_attributes: %i[container_number id _destroy])
  end

  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival)
  end
end
