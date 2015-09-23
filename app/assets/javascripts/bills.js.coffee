$(document).ready ->

  $('#bill_vendor_id').select2()
  $('.select_manage').select2()

  #***** Check if the form has any error then prevent the Form 
  $('body').on 'click', '#billsave', (event)->
    if $('#billsave').closest('form').find('span.form-error:visible').length > 0
      return false
      #event.preventDefault()

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
    $('#add_debit_notes').addClass('disabled', true)

  check_if_vendor_present = ->
      if $('#bill_vendor_id').val() != ''
        $('#add_bill_items').removeClass('disabled')
        $('#add_debit_notes').removeClass('disabled')
        $('#bill_item tbody tr').remove()
        $('#debit_note tbody tr').remove()
        validate_uniquness_of_vendor_invno_invdate()
      else
        $('#bill_item tbody tr').remove()
        $('#add_bill_items').addClass('disabled', true)
        $('#add_debit_notes').addClass('disabled', true)

  $('body').on 'focusout', '#bill_bill_number', ->
    validate_uniquness_of_vendor_invno_invdate()

  $('body').on 'focusout', '#date_restrict', ->
    validate_uniquness_of_vendor_invno_invdate()
 
  #### uniqueness format
  validate_uniquness_of_vendor_invno_invdate = ->
    bill_id = $('#bill_id').val()
    vendor_id = $('#bill_vendor_id').val()
    invoice_no = $('#bill_bill_number').val()
    invoice_date = $('#date_restrict').val()

    if vendor_id && invoice_no && invoice_date
        $.get('/bills/validate_of_uniquness_format', {bill_id: bill_id, vendor_id: vendor_id, invoice_no: invoice_no, invoice_date: invoice_date }).done (data) ->
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
        if !event.field.find(".item_for option[value='" + vendor + "']").length
          event.field.find('.item_for').append($('<option>', { value: vendor, text: vendor }, '</option>'))

  $('body').on 'change', '.item_for', ->
    $item_for =  $(this)
    vendor_id = $('#bill_vendor_id').val()
    if vendor_id
      vendor_type = $('#bill_vendor_id :selected').data('type').split(',')
      charges_associated_vendor = []
      $.each vendor_type, (index, value) ->
        charges_associated_vendor = $.merge(charges_associated_vendor, charges[value])
      item_for = $item_for.closest('tr').find('.item_for :selected').text()
      vendor_charges_classification = charges_classification[item_for]
      vendor_charges_classification = $(charges_associated_vendor).filter(vendor_charges_classification)
      $item_for.closest('tr').find('.vendor_charges option').remove()
      $.each vendor_charges_classification, (index, value) ->
        if !$item_for.closest('tr').find(".vendor_charges option[value='" + value + "']").length
          $item_for.closest('tr').find('.vendor_charges').append($('<option>', {value: value, text: value},'</option>'))
    $(this).closest('tr').find('.item_number').val('')
    $(this).closest('tr').find('.vendor_charges').val('')
    $(this).closest('tr').find('.quantity').val('')
    $(this).closest('tr').find('.rate').val('')
    $(this).closest('tr').find('.line_amount').val('')
    if $(this).closest('tr').find('.item_for').val() == ''
      $(this).closest('tr').find('.item_number').val('') 
      $(this).closest('tr').find('.vendor_charges option').remove()
    else
      if item_for == 'container'
        $item_for.closest('tr').find('.quantity').val(1)
        $item_for.closest('tr').find('.quantity').prop('readonly', true)
      else
        $item_for.closest('tr').find('.quantity').prop('readonly', false)

  $(document).on 'nested:fieldAdded', (event) ->
    $('select.select_manage').select2()
    add_bill_items(event)  #***** Add bill_items

  #********* Validate Item Number
  $('body').on 'focusout','.item_number', ->
    current_row_item_number = $(this).closest('tr').find('.item_number')
    current_row = $(this).closest('tr')
    vendor_id = $('#bill_vendor_id').val()
    item_type = $(this).closest('tr').find('.item_type').val()
    item_for = $(this).closest('tr').find('.item_for').val()
    item_number = $(this).closest('tr').find('.item_number').val()

    $.get('/bills/validate_item_number', {vendor_id: vendor_id, item_type: item_type, item_for: item_for, item_number: item_number
                                         }).done (data) ->
      if data.result is null
        if current_row_item_number.parent('div').children('span').length > 0
        else
          current_row_item_number.parent('div').addClass('has-error')
          current_row_item_number.parent('div').append("<span class='help-block form-error'> Bl or Container not found </span>")
      else
        current_row_item_number.parent('div').removeClass('has-error')
        current_row_item_number.parent('div').find('span').remove()
        type = current_row.find('.item_type').val()
        current_row.find('.activity_id').val(data.result)
        current_row.find('.activity_type').val(type)

  $('body').on 'change', '.item_type', -> #Import OR EXPORT
    # ******** Reinitialize the Row 
    $(this).closest('tr').find('.item_for').val('')
    $(this).closest('tr').find('.item_number').val('')
    #$(this).closest('tr').find('.vendor_charges').select2('val', 'All')
    $(this).closest('tr').find('.quantity').val('')
    $(this).closest('tr').find('.rate').val('')
    $(this).closest('tr').find('.line_amount').val('')

  #********** Checking for same container number, can not accept the same item twice
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

  #************* validate number for debit note

  $('body').on 'focusout', '.debit_note_number', ->
    current_row_number = $(this).closest('tr').find('.debit_note_number')
    debit_note_type = $(this).closest('tr').find('.debit_note_for').val()
    debit_note_number = $(this).closest('tr').find('.debit_note_number').val()

    if debit_note_type
      $.get('/bills/validate_debit_note_number', {
        debit_note_type: debit_note_type, debit_note_number: debit_note_number
      }).done (data) ->
        if data.result is false
          if current_row_number.parent('div').children('span').length > 0
          else
            current_row_number.parent('div').addClass('has-error')
            current_row_number.parent('div').append("<span class='help-block form-error'> Bl or Container not found </span>")
        else
          current_row_number.parent('div').removeClass('has-error')
          current_row_number.parent('div').find('span').remove()

  #**************************************

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

