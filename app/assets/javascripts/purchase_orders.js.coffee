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
    $('.purchase_order_purchase_order_items_of_type').width(170)
    $('.purchase_order_purchase_order_items_of_type').css({ marginRight: "-65px" })
    $('.purchase_order_purchase_order_items_truck_id').width(226)
    $('.purchase_order_purchase_order_items_truck_id').css({ marginRight: '-50px'})
    $('.purchase_order_purchase_order_items_spare_part_id').width(290)
    $('.purchase_order_purchase_order_items_spare_part_id').css({ marginRight: '-60px' })
    $('.purchase_order_purchase_order_items_part_make').width(250)
    $('.total_cost').width(100)

  $(document).on 'click', '.type_of', ->
    $parent = $(this).closest('.fields')
    $('.fields:visible').each (index) ->
      type = $parent.find('.type_of').val()
      console.log('type', type)
      $truck_number_field = $parent.find('.truck_number_id').find('.select2-class')
      console.log('truck number', $truck_number_field)
      if type == 'Stock'
        $truck_number_field.select2('readonly', 'readonly')
        $truck_number_field.val(null).trigger('change')

