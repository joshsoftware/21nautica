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

validate_date = ->
    date_restrict = $(this).parent('div')
    chkdate = $('.date_validation').val()
    if chkdate
      if(!chkdate.match(/^(0[1-9]|[12][0-9]|3[01])[\- \/.](?:(0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
        unless $(this).parent('div').children('span').length > 0
          date_restrict.removeClass('has-success')  if date_restrict.hasClass('has-success')
          date_restrict.addClass('has-error')
          date_restrict.append("<span class='help-block form-error'> Date Format must be Valid(dd-mm-yyyy) </span>")
      else
        date_restrict.removeClass('has-error')
        date_restrict.find('span').remove()

validation_of_form_data = ->
    if $('.payments').closest('form').find('span.form-error:visible').length > 0
      return false

$(document).on "page:load ready", ->
  $("#paid_vendor_id" ).change(show_paid_index_table)
  $("#paid_payment_date").datepicker(
    format :"dd-mm-yyyy")
  $("#paid_payment_date").datepicker('setDate', new Date())
  $('.date_validation').focusout(validate_date)
  $('.payments').click(validation_of_form_data)
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
    if record.voucher_type == 'Payment' || record.voucher_type == 'DebitNote'
      record.amount = -record.amount
    return
  afterFilter: (result) ->
    $('#payment_search_result td.voucher_type').each ->
      if $(this).html() == 'Payment' || $(this).html() == 'DebitNote'
        $(this).parent().addClass 'text-danger'
      else
        paid = $(this).parent().children('td.paid').html()
        amount = $(this).parent().children('td.amount').html()
        if paid == amount
          $(this).parent().addClass 'success'
      return

    paid = 0
    vendor_invoiced = 0
    #adjusted = 0
    for i of result
      if result[i].voucher_type == 'DebitNote' || result[i].voucher_type  == 'Payment'
        #Payment
        paid = paid + result[i].amount
      else
        #vendor_invoice
        vendor_invoiced = vendor_invoiced + result[i].amount
        #adjusted += result[i].paid
    
    outstanding =  (vendor_invoiced + paid).toFixed(2)
    $('#payment_paid_details_result .vendor_invoice').html(vendor_invoiced.toFixed(2))
    $('#payment_paid_details_result .paid').html(-paid.toFixed(2))
    $('#payment_paid_details_result .outstanding').html(outstanding)

