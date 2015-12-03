$(document).ready ->

  #***** Initialize the dataTable
  $('#customers_table').dataTable(
                      {
                        "order": [[0, 'asc' ]],
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                       })

  $('#month').datepicker
    format: 'mm-yyyy'
    viewMode: 'months'
    minViewMode: 'months'
  
  check_customer_name = ->
    customer_val = $('#customer_analysis').val()
    parent_div = $('#customer_analysis').parent('div')

    if !customer_val
      unless $('#customer_analysis').parent('div').children('span').length > 0
        $('#customer_analysis').parent('div').removeClass('has-success')  if parent_div.hasClass('has-success')
        $('#customer_analysis').parent('div').addClass('has-error')
        $('#customer_analysis').parent('div').append("<span class='help-block form-error'> Select Customer Name </span>")
    else
      $('#customer_analysis').parent('div').removeClass('has-error')
      $('#customer_analysis').parent('div').addClass('has-success')
      $('#customer_analysis').parent('div').find('span.form-error').remove()

  validate_month = ->
    month_format = $('#month').parent('div')
    chkdate = $('#month').val()
    if chkdate
      if(!chkdate.match(/^((1[0-2]|0[1-9]|\d)[-](20\d{2}|19\d{2}))$/))
        unless $('#month').parent('div').children('span').length > 0
          $('#month').parent('div').removeClass('has-success')  if month_format.hasClass('has-success')
          $('#month').parent('div').addClass('has-error')
          $('#month').parent('div').append("<span class='help-block form-error'> Date Format must be Valid(mm-yyyy) </span>")
      else
        $('#month').parent('div').removeClass('has-error')
        $('#month').parent('div').find('span').remove()
    else
      unless $('#month').parent('div').children('span').length > 0
        $('#month').parent('div').removeClass('has-success')  if month_format.hasClass('has-success')
        $('#month').parent('div').addClass('has-error')
        $('#month').parent('div').append("<span class='help-block form-error'> Date Format must be Valid(mm-yyyy) </span>")

  $('body').on 'click', '#export_margin_report', ->
    check_customer_name()
    validate_month()
    if $('#analysis_form').closest('form').find('span.form-error:visible').length > 0
      return false
