$(document).ready ->

  $('select.select_manage').select2()

  #***** Initialize the dataTable
  $('#bills').dataTable({
                        "bJQueryUI": true
                        "bFilter": true,
                        "sPaginationType": "full_numbers"
                       })
  #***********************************

  $('#bill_vendor_id').select2()
  $('#bill_item tbody tr:first').hide()

  $('body').on 'change', '#bill_vendor_id', ->
    if $('#bill_vendor_id').val() == ''
      $('#add_bill_items').prop('disabled', true)
    else
      $('#bill_item tbody tr').remove()
      $('#add_bill_items').removeAttr('disabled')

  $(document).on 'nested:fieldAdded', (event) ->
    $('select.select_manage').select2()

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

  $('body').on 'focusout', '.quantity', ->
    $parent = $(this).closest('.fields')
    quantity = $parent.find('.quantity').val()
    rate = $parent.find('.rate').val()
    total_price = (quantity * rate).toFixed(2)
    $parent.find('.line_amount').val(total_price)

  #*********** validator for custom messages

  $.formUtils.addValidator
    name: 'checkTotal'
    validatorFunction: (value, $el, config, language, $form) ->
      amount = 0
      $('.fields .line_amount').each (index) ->
        line_amount = $(this).val()
        amount = amount + parseFloat(line_amount)
      return amount == parseFloat($('.checkTotal').val())
    errorMessage: 'Amount not Match'
    errorMessageKey: 'Amount not Matching'

