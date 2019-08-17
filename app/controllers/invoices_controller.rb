class InvoicesController < ApplicationController
  require 'numbers_in_words/duck_punch'

  def index
    offset_val = params[:offset] || 0
    limit_val = params[:limit] || 100
    @invoices_type = params[:type]
    @invoices = (@invoices_type == 'ready-new') ?
      Invoice.includes(:customer, :invoiceable).where.not(status: 'sent').offset(offset_val).limit(limit_val).order(updated_at: :desc) :
      Invoice.includes(:customer, :invoiceable).where(status: 'sent').offset(offset_val).limit(limit_val).order(updated_at: :desc)
    respond_to do |format|
      format.html{
        @invoice_count = ( @invoices_type == 'ready-new') ? 
          Invoice.where.not(status: 'sent').count : Invoice.where(status: 'sent').count }
      format.json{ render json: @invoices}
    end
  end

  def manual_entry
    render and return if request.get?
    invoice_params = params[:invoice]
    bl_number = BillOfLading.where("lower(bl_number) = ?", invoice_params[:bill_of_lading]).first
    invoice = Invoice.new.tap do |i|
      i.customer_id = invoice_params[:customer_id]
      i.date = invoice_params[:date]
      i.number = invoice_params[:number]
      i.invoiceable = bl_number if bl_number
      i.amount = invoice_params[:amount]
      i.manual = true
      i.save!
      i.invoice_ready!
      i.invoice_sent!
    end
    redirect_to manual_invoices_path
  end

  def manual_invoices
    @invoices = Invoice.where(manual: true)
  end

  def edit
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    @invoice.update_attributes(invoice_params)
    @error = @invoice.errors.full_messages unless @invoice.save
  end

  def new_additional_invoice
    @invoice = Invoice.new
    assign_previous_invoice(@invoice)
    @invoice.document_number = @invoice.previous_invoice.document_number
    @invoice.assign_additional_invoice_number
    respond_to do |format|
      format.js{}
    end
  end

  def additional_invoice
    @invoice = Invoice.new(invoice_params)
    assign_previous_invoice(@invoice)
    @invoice.save ? @invoice.invoice_ready! : @error = @invoice.errors.full_messages
    respond_to do |format|
      format.js {}
    end
  end

  def download
    invoice = Invoice.find(params[:id])
    kit, invoice_type = collect_pdf_data(invoice)
    respond_to do |format|
      format.html {}
      format.pdf {send_data(kit.to_pdf, :filename => "#{invoice_type}.pdf", :type => 'application/pdf')}
    end
  end

  def send_invoice
    invoice = Invoice.find(params[:id])
    if invoice.amount > 0
      kit,invoice_type = collect_pdf_data(invoice)
      pdf = kit.to_pdf
      file = kit.to_file("#{Rails.root}/tmp/#{invoice_type}.pdf")
      UserMailer.mail_invoice(invoice, file).deliver
      invoice.invoice_sent! unless invoice.sent?
    else
      @error = 'cannot send invoice with value 0'
    end
    respond_to do |format|
      format.js {}
    end
  end

  def delete_ledger
    invoice = Invoice.find(params[:id])
    customer_id = invoice.customer_id
    invoice.destroy

    redirect_to readjust_customer_path(customer_id)
  end

  private
  def invoice_params
    params.require(:invoice).permit(:number, :document_number, :amount, :remarks, :date,
      particulars_attributes: [:id, :name, :_destroy, :rate, :quantity, :subtotal])
  end

  def assign_previous_invoice(invoice)
    previous_invoice = Invoice.find(params[:id])
    invoice.previous_invoice = previous_invoice
    invoice.customer = previous_invoice.customer
    invoice.date = Date.current
    invoice.invoiceable = previous_invoice.invoiceable
  end

  def collect_pdf_data(invoice)
    @invoice = invoice
    @particulars = @invoice.particulars
    if (invoice.is_additional_invoice)# this is additional invoice
      invoice_type = "additional_invoice"
      @ref_no = invoice.previous_invoice.number
    elsif invoice.is_import_invoice?
      invoice_type = "import_invoice"
    elsif invoice.is_Haulage_export_invoice?
      invoice_type = "Haulage_export_invoice"
    else
      invoice_type = "TBL_export_invoice"
    end
    html = render_to_string(:action => 'download.html.haml', :layout=> false)
    kit = PDFKit.new(html)
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/invoices.css.scss"
    return kit, invoice_type
  end
end
