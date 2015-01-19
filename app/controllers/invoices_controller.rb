class InvoicesController < ApplicationController
  require 'numbers_in_words/duck_punch'
  def index
    @invoices = Invoice.all
    update_amount @invoices
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update_attributes(invoice_params)
    if invoice.save
      @id = params[:id]
      @amount = invoice.amount
      @document_number = invoice.document_number
      @number = invoice.number
    else 
      @error = invoice.errors.full_messages
    end
  end

  def additional_invoice
    previous_invoice = Invoice.find(params[:id])
    @invoice = Invoice.create(invoice_params)
    @invoice.date = Date.current
    @invoice.previous_invoice = previous_invoice
    @invoice.customer = previous_invoice.customer
    @invoice.invoiceable = previous_invoice.invoiceable
    @invoice.invoice_ready!
    @error = invoice.errors.full_messages unless @invoice.save
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
    kit, invoice_type = collect_pdf_data(invoice)
    pdf = kit.to_pdf
    file = kit.to_file("#{Rails.root}/tmp/#{invoice_type}.pdf")
    UserMailer.mail_invoice(invoice.customer, file).deliver
    invoice.invoice_sent! unless invoice.sent?
    respond_to do |format|
      format.js {}
    end
  end

  private
  def invoice_params
    params.require(:invoice).permit(:number, :document_number, :amount, :perticular)
  end

  def update_amount(invoices)
    invoices.each do |invoice|
      unless invoice.previous_invoice.present?
        amount = invoice.calculate_amount
        invoice.amount = amount
        invoice.save
      end
    end
  end

  def collect_pdf_data(invoice)
    @invoice = invoice
    if (invoice.previous_invoice.present?)# this is additional invoice
      invoice_type = "additional_invoice"
      @ref_no = invoice.previous_invoice.number
      @perticular = invoice.perticular
      @add_charges = invoice.amount
    elsif (invoice.invoiceable.is_a?(BillOfLading) && !invoice.invoiceable.is_export_bl?)
      invoice_type = "import_invoice"
      @charges = invoice.collect_import_invoice_data #import invoice
      import = invoice.invoiceable.import
      @pick_up = import.from
      @destination = import.to
      @equipment = import.equipment
      @quantity = import.quantity
      @job_number = import.work_order_number
    elsif (invoice.invoiceable.is_a?(BillOfLading) && invoice.invoiceable.is_export_bl?)
      invoice_type = "TBL_export_invoice"
      @charges = invoice.collect_export_TBL_data #export TBL
    elsif (invoice.invoiceable.is_a?(Movement))
      invoice_type = "Haulage_export_invoice"
      @charges = invoice.collect_export_haulage_data  #"export Haulage"
      movement = invoice.invoiceable
      @container = movement.container_number
      @pick_up = movement.port_of_discharge
      @destination = movement.port_of_loading
      @equipment = movement.equipment_type
      @quantity = 1
      @job_number = movement.w_o_number
    end
    html = render_to_string(:action => 'download.html.haml', :layout=> false)
    kit = PDFKit.new(html)
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/invoices.css.scss"
    return kit, invoice_type
  end
end
