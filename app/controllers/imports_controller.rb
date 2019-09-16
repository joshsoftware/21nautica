class ImportsController < ApplicationController

  def index
    param =  params[:destination] if params[:destination].present?
    @imports = Import.where.not(status: "ready_to_load").where(to: param || 'Kampala')
    cust_array = Customer.all.select(:id , :name).to_a
    @customers = cust_array.inject({}) {|h,x| h[x.id] = x.name; h}
    @equipment = EQUIPMENT_TYPE.inject({}) {|h, x| h[x] = x; h}
    @clearing_agent = Vendor.clearing_agents.order(:name).pluck(:name).inject({}) {|h, x| h[x] = x; h}
  end

  def new
    @import = Import.new
    @import.build_bill_of_lading
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
    import = Import.find(import_update_params[:id])
    attribute = import_update_params[:columnName].downcase.gsub(' ', '_').to_sym
    if import.update(attribute => import_update_params[:value])
      render text: import_update_params[:value]
    else
      render text: import.errors.full_messages
    end
  end

  def updateStatus
    @import = Import.find(params[:id])
    status = import_params[:status].downcase.gsub(' ', '_')
    @import.remarks.create(desc: import_params[:remarks], date: Date.today, category: "external") unless import_params[:remarks].blank?
    if status != @import.status 
      begin
        @import.send("#{status}!".to_sym)
      rescue
        @import.errors[:work_order_number] = "first enter work order number or entry number"
        @errors = @import.errors.messages.values.flatten
      end
    else
      @import.save
    end
  end

  def retainStatus
    @import = Import.find(params[:id])
  end


  def history
  end

  private

  def import_params
    params.require(:import).permit(:equipment, :quantity, :from, :to, :shipper,
                                   :bl_number, :estimate_arrival, :description,
                                   :customer_id, :rate_agreed, :weight, 
                                   :work_order_number, :remarks, :status, :shipping_line_id, 
                                   import_items_attributes:[:container_number])
  end


  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival)
  end
end

