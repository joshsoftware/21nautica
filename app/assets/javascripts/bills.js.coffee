$(document).ready ->

  $('select.select_manage').select2()
  $('#bill_vendor_id').select2()

  #*********** Turbolinks for document ready
  $(document).on 'ready page:load', (event) ->
    vendor_id = $('#bill_vendor_id').val()
    
    $('.fields .item_for').each (index) ->
      item_for = $(this).closest('tr').find('.item_for').val()
      if item_for == 'container'
        $(this).closest('tr').find('.quantity').val(1)
        $(this).closest('tr').find('.quantity').prop('readonly', true)
  #*********************************

  $('#date_restrict').datepicker
    endDate: '+0d'
    format: 'dd-mm-yyyy'

  #***** Initialize the dataTable
  $('#bills').dataTable(
                      {
                        "order": [[0, 'desc' ]],
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                       })
  #***** end of dataTable

  if $('#bill_vendor_id').val() == ''
    $('#add_bill_items').addClass('disabled', true)
    $('#bill_item tbody tr:first').remove()

  check_if_vendor_present = ->
      if $('#bill_vendor_id').val() != ''
        $('#add_bill_items').removeClass('disabled')
        $('#bill_item tbody tr').remove()
        validate_uniquness_of_vendor_invno_invdate()
      else
        $('#bill_item tbody tr').remove()
        $('#add_bill_items').addClass('disabled', true)

  $('body').on 'focusout', '#bill_bill_number', ->
    validate_uniquness_of_vendor_invno_invdate()

  $('body').on 'focusout', '#date_restrict', ->
    validate_uniquness_of_vendor_invno_invdate()
 
  #### uniqueness format
  validate_uniquness_of_vendor_invno_invdate = ->
    vendor_id = $('#bill_vendor_id').val()
    invoice_no = $('#bill_bill_number').val()
    invoice_date = $('#date_restrict').val()

    if vendor_id && invoice_no && invoice_date
        $.get('/bills/validate_of_uniquness_format', {vendor_id: vendor_id, invoice_no: invoice_no, invoice_date: invoice_date }).done (data) ->
          if data.validate is true
            if $('#bill_bill_number').parent('div').children('span').length > 0
            else
              $('#bill_bill_number').parent('div').addClass('has-error')
              $('#bill_bill_number').parent('div').append("<span class='help-block form-error'> Invoice Number has already taken for for that vendor and date </span>")
          else
            $('#bill_bill_number').parent('div').removeClass('has-error')
            $('#bill_bill_number').parent('div').find('span').remove()

  #************** Vendor selection
  $('body').on 'change', '#bill_vendor_id', ->
      check_if_vendor_present()

  #*********** Adding vendor related charges and bl/container
  add_bill_items = (event) ->
    vendor_id = $('#bill_vendor_id').val()
    if $('#bill_vendor_id').val()
      vendor_type = $('#bill_vendor_id :selected').data('type').split(',')
      $.each vendor_type, (index, value) ->
        vendor = item_for[value]
        event.field.find('.item_for').append($('<option>', { value: vendor, text: vendor }, '</option>'))

  $('body').on 'change', '.item_for', ->
    $item_for =  $(this)
    vendor_id = $('#bill_vendor_id').val()
    if vendor_id
      vendor_type = $('#bill_vendor_id :selected').data('type').split(',')
      $.each vendor_type, (index, value) ->
        charges_associated_vendor = charges[value]
        $.each charges_associated_vendor, (index, value) ->
          $item_for.closest('tr').find('.vendor_charges').append($('<option>', {value: value, text: value},'</option>'))

  $(document).on 'nested:fieldAdded', (event) ->
    $('select.select_manage').select2()
    add_bill_items(event)  #***** Add bill_items

  #********* Validate Item Number
  $('body').on 'focusout','.item_number', ->
    current_row_item_number = $(this).closest('tr').find('.item_number')
    vendor_id = $('#bill_vendor_id').val()
    item_type = $(this).closest('tr').find('.item_type').val()
    item_for = $(this).closest('tr').find('.item_for').val()
    item_number = $(this).closest('tr').find('.item_number').val()

    $.get('/bills/validate_item_number', {vendor_id: vendor_id, item_type: item_type, item_for: item_for, item_number: item_number
                                         }).done (data) ->
      if data.result is false
        if current_row_item_number.parent('div').children('span').length > 0
        else
          current_row_item_number.parent('div').addClass('has-error')
          current_row_item_number.parent('div').append("<span class='help-block form-error'> Bl or Container not found </span>")
      else
        current_row_item_number.parent('div').removeClass('has-error')
        current_row_item_number.parent('div').find('span').remove()


  $('body').on 'change', '.item_type', -> #Import OR EXPORT
    # ******** Reinitialize the Row 
    $(this).closest('tr').find('.item_for').val('')
    $(this).closest('tr').find('.item_number').val('')
    $(this).closest('tr').find('.vendor_charges').select2('val', 'All')
    $(this).closest('tr').find('.quantity').val('')
    $(this).closest('tr').find('.rate').val('')
    $(this).closest('tr').find('.line_amount').val('')

  $('body').on 'change','.item_for', ->
    # ******** Reinitialize the Row (Except Item type) 
    $(this).closest('tr').find('.item_number').val('')
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

  #********** Checking for same container number, can not accept the same item twice
  #$('body').on 'select2-close', '.vendor_charges', ->
  $('body').on 'change', '.vendor_charges', ->
    vendor_container = []
    current_tr = $(this).closest('tr')
    #current_value = current_tr.find(".item_number").select2('val') + ":" + current_tr.find('.vendor_charges').select2('val')# e.object.text
    current_value = current_tr.find(".item_number").val() + ":" + current_tr.find('.vendor_charges').val()#.select2('val')# e.object.text
    current_tr.addClass('check_charges')

    $('#bill_item tbody tr').each ->
      if $(this).hasClass('check_charges') == false
        container_number = $(this).find('.item_number:visible').val()
        vendor_charges = $(this).find('.vendor_charges:visible').val() #select2('val')
        
        temp = container_number + ":" + vendor_charges
        vendor_container.push(temp)
        #if (vendor_container.indexOf(current_value) > -1)
        if (vendor_container.indexOf(current_value) != -1)
          alert('Vendor or Invoice already booked for that item')
          current_tr.find('.vendor_charges').val('') #select2('val', '')
          current_tr.removeClass('check_charges')
          return false
    current_tr.removeClass('check_charges')
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
      $('.fields .line_amount:visible').each (index) ->
        amount = amount + parseFloat($(this).val())
      return amount == parseFloat($('.checkTotal').val())
    errorMessage: 'Amount not Match'
    errorMessageKey: 'Amount not Matching'

