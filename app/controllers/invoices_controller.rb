class InvoicesController < ApplicationController
  require 'numbers_in_words/duck_punch'
  def index
    @invoices = Invoice.all
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
    @invoice.invoice_ready!
    @error = invoice.errors.full_messages unless @invoice.save
  end

  def download
    invoice = Invoice.find(params[:id])
    kit = collect_pdf_data(invoice)
    respond_to do |format|
      format.html {}
      format.pdf {send_data(kit.to_pdf, :filename => "invoice.pdf", :type => 'application/pdf')}
    end
  end

  def send_invoice
    invoice = Invoice.find(params[:id])
    kit = collect_pdf_data(invoice)
    pdf = kit.to_pdf
    file = kit.to_file("#{Rails.root}/tmp/invoice.pdf")
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
      unless invoice.is_additional_invoice?
        amount = invoice.calculate_amount
        invoice.amount = amount
        invoice.save
      end
    end
  end

  def collect_pdf_data(invoice)
    @invoice = invoice
    html = render_to_string(:action => 'download.html.haml', :layout=> false)
    kit = PDFKit.new(html)
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/invoices.css.scss"
    return kit
  end
end
