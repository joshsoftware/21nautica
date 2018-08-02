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

  $('body').on 'focusout', '.req_price', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.req_quantity').val()
    price = $parent.find('.req_price').val()
    total_price = (quantity * price).toFixed(2)
    $parent.find('.total_cost').val(total_price)

  $('body').on 'focusout', '.req_quantity', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.req_quantity').val()
    price = $parent.find('.req_price').val()
    total_price = (quantity * price).toFixed(2)
    $parent.find('.total_cost').val(total_price)

  $('body').on 'change', '.spare_part_id', ->
    $('.fields .spare_part_id').each (index) ->
      spare_part_id = $(this).closest('tr').find('.spare_part').val()
      $spare_part_description = $(this).closest('tr')
      if spare_part_id
        $.get('/req_sheets/load_spare_part', {spare_part_id: spare_part_id }).done (data) ->
          $spare_part_description.find('.req_part_description').val(data.description)
