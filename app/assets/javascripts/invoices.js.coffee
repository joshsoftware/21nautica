# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

validate_invoice_form = ->
  $.validate
    form: "#invoice_form"
    scrollToTopOnError: false
  return

containers_quantity = (value, containers) ->
  quantity = if value in ["ICD", "Demurrage", "Empty", "Final Clearing", "Haulage", "Forest Permits"] then containers else 1

calculate_amount = ->
  amount = 0
  $('.subtotal').each ->
    amount = parseInt(amount) + parseInt($(this).val())

  removed_amount = 0
  $('.fields[style*="display: none;"] .subtotal').each ->
    removed_amount = parseInt(removed_amount) + parseInt($(this).val())
  return (amount - removed_amount)

load_particular_select_and_rate_event = ->
  $(".myselect").change ->
    value = $(this).find(".form-control").val()
    if value is "Other"
      select_name = $(this).find(".form-control").attr("name")
      new_input = $(this).find('.form-control').replaceWith('<input type="text" name=' + select_name + ' data-validation-error-msg="Enter particular" data-validation="required" class="form-control">')

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

  $(".quantity").change ->
    qty = $(this).val()
    rate = $(this).closest(".fields").find(".rate").val()
    $(this).closest(".fields").find(".subtotal").val (rate * qty)
    $('#invoiceUpdateModal #invoice_amount input').val(calculate_amount)

load_nested_form_events = ->
  $(document).on "nested:fieldAdded", (event) ->
    load_particular_select_and_rate_event()

  $(document).on "nested:fieldRemoved", (event) ->
    $('.fields[style*="display: none;"] .form-control').each ->
      $(this).removeAttr("data-validation")
    $('.fields[style*="display: none;"] .rate').each ->
      $(this).removeAttr("data-validation")
    $('.fields[style*="display: none;"] .quantity').each ->
      $(this).removeAttr("data-validation")

    $('#invoiceUpdateModal #invoice_amount input').val(calculate_amount)

loadupdatemodal = ->
  $('#invoiceUpdateModal').on 'show.bs.modal', (event) ->
    validate_invoice_form()
    $('#invoiceUpdateModal #invoice_amount').attr('readonly','readonly')
    load_particular_select_and_rate_event()

  $('#invoiceUpdateModal').on 'hide.bs.modal', (event) ->
    $('#invoiceUpdateModal .alert').remove()
    $('#invoiceUpdateModal .fields').remove()

stream_table_function = ->
  template = Mustache.compile($.trim($('#invoices_search_result_template').html()))

  view = (record, index) ->
    template
      record: record
      index: index

  callbacks =
    after_add: ->
      if count is this.data.length
        $(".streaming_div").hide()

  if($("#invoices_index_table").length)
    options =
      view: view
      data_url: '/invoices/ready-new'
      callbacks: callbacks
      stream_after: 2
      fetch_data_limit: 100
      search_box: '#invoices_searchbox'
      pagination:
        per_page_select: '#invoices_per_page'
    window.st = StreamTable('#invoices_index_table', options, data)

  if($("#sent_invoices_table").length)
    options =
      view: view
      data_url: '/invoices/sent'
      callbacks: callbacks
      stream_after: 2
      fetch_data_limit: 100
      search_box: '#invoices_searchbox'
      pagination:
        per_page_select: '#invoices_per_page'
    window.st = StreamTable('#sent_invoices_table', options, data)

load_invoice_functions = ->
  stream_table_function()
  loadupdatemodal()
  load_nested_form_events()

$(document).ready(load_invoice_functions)
