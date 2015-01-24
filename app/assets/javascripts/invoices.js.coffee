# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

containers_quantity = (value, containers) ->
  quantity = if value in ["ICD", "Demurrage", "Empty", "Final Clearing", "Haulage", "Forest Permits"] then containers else 1

calculate_amount = ->
  amount = 0
  $('.subtotal').each ->
    amount = parseInt(amount) + parseInt($(this).val())
  return amount

@load_nested_form_events = ->
  $(document).on "nested:fieldAdded", (event) ->
    $(".myselect").change ->
      value = $(this).find(".select.optional:eq(1)").val()
      if value is "Other"
        select_name = $(this).find(".select.optional:eq(1)").attr("name")
        new_input = $(this).find('.select').replaceWith('<input type="text" name=' + select_name + ' data-validation="required" data-validation-error-msg="add particular">')

      quantity = containers_quantity(value, containers)
      rate = $(this).closest(".fields").find(".rate").val()
      $(this).closest(".fields").find(".quantity").val quantity
      $(this).closest(".fields").find(".subtotal").val (quantity * rate)
      $('#invoiceUpdateModal #invoice_amount input').val(calculate_amount)

    $(".rate").change ->
      rate = $(this).val()
      qty = $(this).closest(".fields").find(".quantity").val()
      $(this).closest(".fields").find(".subtotal").val (rate * qty)
      $('#invoiceUpdateModal #invoice_amount input').val(calculate_amount)

  $(document).on "nested:fieldRemoved", (event) ->
    $('.fields[style*="display: none;"]').remove()
    $('#invoiceUpdateModal #invoice_amount input').val(calculate_amount)


@InvoiceFilterInit = ->
  FilterJS invoices, "#invoices_search_result",
    template: "#invoices_search_result_template"
    search:
      ele: "#invoices_searchbox"

@loadupdatemodal = ->
  $('#invoiceUpdateModal').on 'show.bs.modal', (event) ->
    $('#invoiceUpdateModal #invoice_amount').attr('readonly','readonly')
    $(".myselect").change ->
      value = $(this).find(".select.optional:eq(1)").val()
      if value is "Other"
        select_name = $(this).find(".select.optional:eq(1)").attr("name")
        new_input = $(this).find('.select').replaceWith('<input type="text" name=' + select_name + ' data-validation="required" data-validation-error-msg="add particular">')

      quantity = containers_quantity(value, containers)
      rate = $(this).closest(".fields").find(".rate").val()
      $(this).closest(".fields").find(".quantity").val quantity
      $(this).closest(".fields").find(".subtotal").val (quantity * rate)
      $('#invoiceUpdateModal #invoice_amount input').val(calculate_amount)

    $(".rate").change ->
      rate = $(this).val()
      qty = $(this).closest(".fields").find(".quantity").val()
      $(this).closest(".fields").find(".subtotal").val (rate * qty)
      $('#invoiceUpdateModal #invoice_amount input').val(calculate_amount)


  $('#invoiceUpdateModal').on 'hide.bs.modal', (event) ->
    $('#invoiceUpdateModal .alert').remove()
    $('#invoiceUpdateModal .fields').remove()

@load_additional_invoice_modal = ->
  $('#AdditionalInvoiceModal').on 'show.bs.modal', (event) ->
    link_tag = $(event.relatedTarget)
    id = link_tag.attr('data-invoice-id')
    $('#AdditionalInvoiceModal form').attr('action', "/invoices/" + id + "/additional-invoice")
