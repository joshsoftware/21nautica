$(document).ready ->
  #***** Initialize the dataTable
  $('#purchase_order_table').dataTable(
                      {
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                      })
  $('body').on 'focusout', '.purchase_order_quantity', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.purchase_order_quantity').val()
    price = $parent.find('.purchase_order_price').val()
    total_price = (quantity * price).toFixed(2)
    $parent.find('.total_cost').val(total_price)
    calculate_purchase_order()
  
  $('body').on 'focusout', '.purchase_order_price', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.purchase_order_quantity').val()
    price = $parent.find('.purchase_order_price').val()
    total_price = (quantity * price).toFixed(2)
    $parent.find('.total_cost').val(total_price)
    calculate_purchase_order()

  $(document).on 'nested:fieldAdded', (event) ->
    event.field.closest('tr').find('.select2-class').select2()

  $(document).on 'nested:fieldRemoved', (event) ->
    calculate_purchase_order()
    
  calculate_purchase_order = ->
    amount = 0
    $('.fields:visible').each (index) ->
      quantity = $(this).find('.purchase_order_quantity').val()
      price = $(this).find('.purchase_order_price').val()
      total_price = (quantity * price).toFixed(2)
      amount = amount + parseFloat(total_price)
    $('#purchase_order_total_cost').val(amount.toFixed(2))

  $(document).on 'click', '#add_purchase_order_items', ->
    console.log('boom')
    $('.truck_number_id').width(230)
    $('.spare_part_id').width(230)
    $('.part_make').width(230)
    $('.total_cost').width(100)