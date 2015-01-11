class InvoicesController < ApplicationController
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
    @invoice.bill_of_lading = previous_invoice.bill_of_lading
    @error = invoice.errors.full_messages unless @invoice.save
  end

  private
  def invoice_params
    params.require(:invoice).permit(:number, :document_number, :amount)
  end
end
