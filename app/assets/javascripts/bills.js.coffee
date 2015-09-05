$(document).ready ->

  $('#bill_vendor_id').select2()
  $('body').on 'change', '#bill_vendor_id', ->
    if $('#bill_vendor_id').val() == ''
      $('#add_bill_items').prop('disabled', true)
    else
      $('#bill_item tbody tr').remove()
      $('#add_bill_items').removeAttr('disabled')

  $(document).on 'nested:fieldAdded', (event) ->
    field = event.field
    item_number = field.find('.item_number')
    item_number.select2()

    field = event.field
    vendor_charges = field.find('.vendor_charges')
    vendor_charges.select2()

    vendor_name = $('#bill_vendor_id :selected').text()
    if vendor_name
      #********** Add Item --> BL/Container
      $.get('/bills/get_container', { vendor_name: vendor_name } )
      #******* Get  vendor related charges 
      $.get('/bills/load_vendor_charges', { vendor_name: vendor_name })

  $('body').on 'change', '.item_type', -> #Import OR EXPORT
    # ******** Reinitialize the Row 
    $(this).closest('tr').find('.item_for').val('')
    $(this).closest('tr').find('.item_number').select2('val', 'All')
    $(this).closest('tr').find('.vendor_charges').select2('val', 'All')
    $(this).closest('tr').find('.quantity').val('')
    $(this).closest('tr').find('.rate').val('')
    $(this).closest('tr').find('.line_amount').val('')

  $('body').on 'change','.item_for', ->
    # ******** Reinitialize the Row (Except Item type) 
    $(this).closest('tr').find('.item_number').select2('val', 'All')
    $(this).closest('tr').find('.vendor_charges').select2('val', 'All')
    $(this).closest('tr').find('.quantity').val('')
    $(this).closest('tr').find('.rate').val('')
    $(this).closest('tr').find('.line_amount').val('')
    if $(this).closest('tr').find('.item_for').val() == ''
      $(this).closest('tr').find('.item_number option').remove()
    else
      vendor_id = $('#bill_vendor_id').val()
      item_type = $(this).closest('tr').find('.item_type').val() ## Import OR Export
      item_for =  $(this).closest('tr').find('.item_for').val() ## container OR bl
      if item_for == 'container'
        $(this).closest('tr').find('.item_number option').remove()
        $('.quantity').val(1)
        $('.quantity').prop('readonly', true)
        #******* Get Container Number
        $.get('/bills/get_number', { vendor_id: vendor_id, item_type: item_type, item_for: item_for } )
      else
        #******* Get bl Number
        $.get('/bills/get_number', { vendor_id: vendor_id, item_type: item_type, item_for: item_for } )


  #********** Checking for same container number, can not accept the same item twice
  $('body').on 'select2-close', '.vendor_charges', ->
    vendor_container = []
    current_tr = $(this).closest('tr')
    current_value = current_tr.find(".item_number").select2('val') + ":" + current_tr.find('.vendor_charges').select2('val')# e.object.text
    console.log current_value

    $('#bill_item tbody tr:not(last)').each ->
      container_number = $(this).find('.item_number').select2('val')
      vendor_charges = $(this).find('.vendor_charges').select2('val')
      
      temp = container_number + ":" + vendor_charges
      #if (vendor_container.indexOf(current_value) > -1)
      if (vendor_container.indexOf(current_value) != -1)
        alert('Vendor or Invoice already booked for that item')
        current_tr.find('.vendor_charges').select2('val', '')
        return false
      vendor_container.push(temp)
  #*************************************

  $('body').on 'focusout', '.rate', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.quantity').val()
    rate = $parent.find('.rate').val()
    total_price = (quantity * rate).toFixed(2)
    $parent.find('.line_amount').val(total_price)

  #*********** validator for custom messages
  jQuery.validator.classRuleSettings.checkTotal = { checkTotal: true };

  jQuery.validator.addMethod 'checkTotal', ((value) ->
    alert('value')
    total_price = 0
    $('#bill_item .fields:visible').each (index) ->
      quantity = $('.fields').find('.quantity').val()
      rate = $('.fields').find('.rate').val()
      total_price = total_price + (quantity * rate).toFixed(2)
      console.log total_price

    return $('#bill_value') == total_price
  ), 'Amount not match for Line Amount!'

