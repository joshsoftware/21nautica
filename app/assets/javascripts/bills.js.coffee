
$(document).ready ->

  $('select').select2()
  $('body').on 'change', '#bill_vendor_id', ->
    if $('#bill_vendor_id').val() == ''
      $('#add_bill_items').prop('disabled', true)
    else
      vendor_name = $('#bill_vendor_id :selected').text()
      $('#bill_item tbody tr').remove()
      $('#add_bill_items').removeAttr('disabled')

      #******* Get  vendor related charges 
      $.get('/bills/get_vendor_charges', { vendor_name: vendor_name })

  add_item_type_for_vendor = ->
    vendor_name = $('#bill_vendor_id :selected').text()
    #********** Add Item --> BL/Container
    $.get('/bills/get_container', { vendor_name: vendor_name } )

  $(document).on 'nested:fieldAdded', (event) ->
    $('select').select2()
    add_item_type_for_vendor()

  $('body').on 'change','#item_for', ->
    vendor_id = $('#bill_vendor_id').val()
    item_type = $('#item_type').val()
    item_for = $('#item_for :selected').val()
    if item_for == 'container'
      $('#quantity').val(1)
      $('#quantity').prop('readonly', true)

      #******* Get Container Number
      $.get('/bills/get_number', { vendor_id: vendor_id, item_type: item_type, item_for: item_for } )
