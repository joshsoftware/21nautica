# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  #***** Initialize the dataTable
  $('#req_sheet_table').dataTable(
                      {
                        "order": [[0, 'asc' ]],
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                       })

  $(document).on 'nested:fieldAdded', (event) ->
    event.field.closest('tr').find('.select2').select2()

  $(document).on 'nested:fieldRemoved', (event) ->
    calculate_price()

  $('body').on 'focusout', '.req_price', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.req_quantity').val()
    price = $parent.find('.req_price').val()
    total_price = (quantity * price).toFixed(2)
    $parent.find('.total_cost').val(total_price)
    calculate_price()

  $('body').on 'focusout', '.req_quantity', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.req_quantity').val()
    price = $parent.find('.req_price').val()
    total_price = (quantity * price).toFixed(2)
    $parent.find('.total_cost').val(total_price)
    calculate_price()

  calculate_price = -> 
    amount = 0
    $('.fields:visible').each (index) ->
      quantity = $(this).find('.req_quantity').val()
      price = $(this).find('.req_price').val()
      total_price = (quantity * price).toFixed(2)
      amount = amount + parseFloat(total_price)
    $('#req_sheet_value').val(amount.toFixed(2))


  $('body').on 'change', '.spare_part_id', ->
    $('.fields .spare_part_id').each (index) ->
      spare_part_id = $(this).closest('tr').find('.spare_part').select2('val')
      $spare_part_description = $(this).closest('tr')
      if spare_part_id
        $.get('/req_sheets/load_spare_part', {spare_part_id: spare_part_id }).done (data) ->
          $spare_part_description.find('.req_part_description').val(data.description)

  $('body').on 'change', '#req_sheet_truck_id', ->
    truck_id = $(this).select2('val')
    if truck_id
      $.get('/req_sheets/check_truck_type', {truck_id: truck_id}).done (flag) ->
        if !flag
          $('.req_sheet_km').toggle()
