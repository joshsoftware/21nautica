# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

containers_quantity = (value) ->
  quantity = if value in ["ICD", "Demurrage", "Empty", "Final Clearing", "Haulage", "Forest Permits"] then containers else 1

@load_nested_form_events = ->
  $(document).on "nested:fieldAdded", (event) ->
    field = event.field
    select_field = field.find(".myselect")
    select_field.change ->
      value = $(this).find(".select.optional:eq(1)").val()
      if value is "Other"
        select_name = $(this).find(".select.optional:eq(1)").attr("name")
        new_input = $(this).find('.select').replaceWith('<input type="text" name=' + select_name + ' data-validation="required" data-validation-error-msg="add particular">')

      containers = containers_quantity(value)
      rate = $(this).closest(".fields").find(".rate").val()
      $(this).closest(".fields").find(".quantity").val containers
      $(this).closest(".fields").find(".subtotal").val (containers * rate)

      amount = 0
      $('.subtotal').each ->
        amount = parseInt(amount) + parseInt($(this).val())
      $('#invoiceUpdateModal #invoice_amount').val amount + prev_amount

    rate_field = field.find(".rate")
    rate_field.change ->
      rate = $(this).val()
      qty = $(this).closest(".fields").find(".quantity").val()
      $(this).closest(".fields").find(".subtotal").val (rate * qty)
      amount = 0
      $('.subtotal').each ->
          amount = parseInt(amount) + parseInt($(this).val())
      $('#invoiceUpdateModal #invoice_amount').val amount + prev_amount

@InvoiceFilterInit = ->
  FilterJS invoices, "#invoices_search_result",
    template: "#invoices_search_result_template"
    search:
      ele: "#invoices_searchbox"

@loadupdatemodal = ->
  $('#invoiceUpdateModal').on 'show.bs.modal', (event) ->
    link_tag = $(event.relatedTarget)
    id = link_tag.attr('data-invoice-id')
    row = $("#invoices_index_table tr[invoice_id= '" + id + "']")
    row_class = link_tag.attr('data-row-class')
    window.containers = link_tag.attr('data-total-containers')

    $('#invoiceUpdateModal #customer_name label').text("Customer Name : 
    " + $(row).find("td.customer").text())
    
    $('#invoiceUpdateModal #bl_number label').text("BL Number : 
    " + $(row).find("td.bl_num").text())

    $('#invoiceUpdateModal #invoiced_date label').text("Invoice Date : 
    " + $(row).find("td.date").text())
    
    $('#invoiceUpdateModal #invoice_number').val $(row).find("td.number").text()
    $('#invoiceUpdateModal #invoice_document_number').val $(row).find("td.document_num").text()
    $('#invoiceUpdateModal #invoice_amount').val $(row).find("td.amount").text()
    $('#invoiceUpdateModal #invoice_amount').attr('readonly','readonly')
    window.prev_amount = parseInt($('#invoiceUpdateModal #invoice_amount').val())

    $('#invoiceUpdateModal form').attr('action', "/invoices/" + id )

  $('#invoiceUpdateModal').on 'hide.bs.modal', (event) ->
    $('#invoiceUpdateModal #invoice_amount').removeAttr('readonly')
    $('#invoiceUpdateModal .alert').remove()
    $('#invoiceUpdateModal .fields').remove()

@load_additional_invoice_modal = ->
  $('#AdditionalInvoiceModal').on 'show.bs.modal', (event) ->
    link_tag = $(event.relatedTarget)
    id = link_tag.attr('data-invoice-id')
    $('#AdditionalInvoiceModal form').attr('action', "/invoices/" + id + "/additional-invoice")