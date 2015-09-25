# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
      
show_paid_index_table = ->
  vendor_id = $(this).val()
  if vendor_id
    $.ajax
      url: "/paid"
      type: "GET"
      data:
        vendor_id: vendor_id

$(document).on "page:load ready", ->
  $("#paid_vendor_id" ).change(show_paid_index_table)
  $("#paid_payment_date").datepicker(
    format :"dd-mm-yyyy")
  $("#paid_payment_date").datepicker('setDate', new Date())
  return

window.PaidFilterInit = ->
  FJS = FilterJS(payments, '#payment_search_result',
    template: '#payment_search_result_template'
    callbacks: callbacks
    search: {})
  FJS.addCriteria
    field: 'date'
    ele: '#filter_by_days_select'
    type: 'range'
  return

callbacks = 
  beforeRecordRender: (record) ->
    if record.voucher_type == 'Bill'
      record.amount = record.amount
    return
