class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.where(previous_invoice_id: nil)
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
    invoice = Invoice.create(invoice_params)
    invoice.previous_invoice = previous_invoice
    @error = invoice.errors.full_messages unless invoice.save
  end

  private
  def invoice_params
    params.require(:invoice).permit(:number, :document_number, :amount)
  end
end
