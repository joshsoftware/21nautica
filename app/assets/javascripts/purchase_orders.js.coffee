$(document).ready ->
  #***** Initialize the dataTable
  $('#purchase_order_table').dataTable(
                      {
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                      }).makeEditable(
                        sUpdateURL: 'purchase_orders/update',
                        aoColumns: [
                          { sUpdateURL: (value,settings) ->
                            row = $(this).parents('tr')[0]
                            id = row.id
                            $.ajax(
                              url:"purchase_orders/#{id}/update_inv_number",
                              type: 'POST'
                              data: {id:id,columnName:"File Ref Number",value:value},
                              async: false)
                              .done((data) ->
                                if (data != value)
                                  value = data
                              )
                            return value
                          , placeholder:"Click to enter",
                          fnOnCellUpdated: (sStatus, sValue, settings) ->
                            $.post("imports/#{id}/retainStatus")
                          },
                          null, null, null, null, null
                        ]
                      )
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
      $truck_number_field = $parent.find('.truck_number_id').find('.select2-class')
      if type == 'Stock'
        $truck_number_field.select2('readonly', 'readonly')
        $truck_number_field.val(null).trigger('change')

  $(document).on 'change', '#report_type', ->
    $field = $('#report_field')
    $field.find('option').remove().end()
    $field.append $("<option val=''></option>")
    lpo_list = [['supplier_id', 'Supplier Name'], ['truck_id', 'Truck Number'], ['spare_part_id', 'Part Name']]
    req_list = [['truck_id', 'Truck Number'], ['spare_part_id', 'Part Name']]
    if $(this).val() == 'LPO'
      $.each lpo_list, (index, value) ->
        $field.append('<option value='+value[0]+'>'+value[1]+'</option>')
    else if $(this).val() == 'REQ'
      $.each req_list, (index, value) ->
        $field.append('<option value='+value[0]+'>'+value[1]+'</option>')

  $(document).on 'change', '#report_field', ->
    $field = $('#report_value')
    $field.select2('val', '')
    $field.find('option').remove().end()
    $field.append $("<option val=''></option>")
    if $(this).val() == 'supplier_id'
      $.each suppliers, (index, value) ->
        $field.append('<option value='+value[0]+'>'+value[1]+'</option>')
      $field.append(new Option("ALL", "ALL"))
    else if $(this).val() == 'spare_part_id'
      $.each spare_parts, (index, value) ->
        $field.append('<option value='+value[0]+'>'+value[1]+'</option>')
      $field.append(new Option("ALL", "ALL"))
    else if $(this).val() =='truck_id'
      $.each trucks, (index, value) ->
        $field.append('<option value='+value[0]+'>'+value[1]+'</option>')
      $field.append(new Option("ALL", "ALL"))

