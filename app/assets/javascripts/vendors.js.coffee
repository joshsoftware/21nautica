# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  #$('body').on 'click', '#vendor_save', ->
  #  #*********** checks if the form has any span with form-error then do not submit form
  #  if $('#vendor_save').closest('form').find('span.form-error:visible').length > 0
  #    return false

  #***** Initialize the dataTable
  $('#vendors_table').dataTable(
                      {
                        "order": [[0, 'desc' ]],
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                       })
  #***** end of dataTable
  
  checkAtLeastOneType = ->
    count = $("#vendor_list option:selected").length
    if count
      unless $("#vendor_list option:selected").length > 0
          $('#vendor_list').parent('div').removeClass('has-success').addClass('has-error')
          $('#vendor_list').parent('div').append("<span class='help-block form-error'> Select at least 1 type </span>")
    else
      $('#vendor_list').parent('div').removeClass('has-error')
      $('#vendor_list').parent('div').find('span').remove()

  #******************** multiselect plugin
  $('#vendor_list').multiselect
    enableFiltering: true
    filterBehavior: 'value'

    #*********** callback to check whether any type is selected or not 
    # if not then append the span 
    #onDropdownHide: (event) ->
    #  checkAtLeastOneType()


