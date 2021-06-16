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
    if @import.save!
      @import.import_items.destroy_all if @import.order_type == ORDER_TYPE.last
      @import.update(quantity: @import.import_items.count, remaining_weight: @import.weight, remaining_quantity: @import.item_quantity)
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
      @order_type = @import.order_type
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
      if import_params[:bl_number].present? && @import.bl_number != import_params[:bl_number]
        unless @import.bill_of_lading.update(bl_number: import_params[:bl_number])
          flash[:error] = @import.bill_of_lading.errors.full_messages.join(', ')
          @customers = Customer.all
          @order_type = @import.order_type
          render 'edit'
          return
        end
      end
      if @import.update_attributes(import_params)
        @import.import_items.destroy_all if @import.order_type == ORDER_TYPE.last
        @import.update(quantity: @import.import_items.count)
        flash[:notice] = I18n.t 'import.update'
        redirect_to :imports
      else
        @customers = Customer.all
        @order_type = @import.order_type
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

  def edit_import_customer
    if params[:searchValue].present?
      @imports = Import.joins(:customer).select("customers.name as customer_name, *, quantity, imports.id as id")
                       .where("bl_number ILIKE :query OR work_order_number ILIKE :query", query: "%#{params[:searchValue]}%")
    else
      @imports = Import.none
    end
    respond_to do |format|
      format.html {}
      format.json {
        render json: {:data => @imports.offset(params[:start]).limit(params[:length] || 10).as_json,
                      "recordsTotal" => @imports.to_a.count, "recordsFiltered" => @imports.to_a.count}
      }
    end
  end

  def edit_customer_modal
    @import = Import.find(params[:id])
    @customers = Customer.order(:name)
  end

  def update_customer
    import = Import.find(params[:id])
    old_customer_id = import.customer_id
    customer_id = params[:import][:customer_id]
    if customer_id.present?
      import.update(customer_id: customer_id)
      if import.bill_of_lading.present? && import.bill_of_lading.invoices.present?
        invoices = import.bill_of_lading.invoices
        invoices.update_all(customer_id: customer_id)
        readjust_on_customer_change(old_customer_id)
        readjust_on_customer_change(customer_id)
      end
    end
    respond_to do |format|
      format.js {
        render inline: "location.reload();"
        flash[:notice] = I18n.t 'import.update'
      }
    end
  end

  def destroy
    import = Import.find_by_id(params['id'])
    if import.present? && import.destroy
      flash[:notice] = "Import order deleted Successfully"
    else
      flash[:error] = "Could not delete the Import order!"
    end
    redirect_to imports_path
  end

  private

  def import_params
    params.require(:import).permit(:quantity, :from, :to, :shipper,
                                   :bl_number, :estimate_arrival, :description,
                                   :customer_id, :rate_agreed, :weight,
                                   :work_order_number, :remarks, :status,
                                   :shipping_line_id,
                                   :bl_received_type, :consignee_name,
                                   :item_quantity, :item_weight, :order_type,
                                   import_items_attributes: %i[container_number id _destroy equipment item_weight item_quantity])
  end

  def import_update_params
    params.permit(:id, :columnName, :value, :clearing_agent, :estimate_arrival)
  end

  def readjust_on_customer_change(customer_id)
    customer = Customer.find(customer_id)
    # Remove all legders for the customer
    Ledger.where(customer: customer).delete_all
    # Add all invoice ledgers
    customer.invoices.order(date: :asc).sent.each do |inv|
      inv.create_ledger(amount: inv.amount, customer: inv.customer, date: inv.date, received: 0)
    end
    # Add all received ledgers
    customer.payments.order(date_of_payment: :asc).each do |payment|
      payment.create_ledger(amount: payment.amount, customer: payment.customer, date: payment.date_of_payment)
    end
  end
end
