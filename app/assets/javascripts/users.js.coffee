# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  #***** initialize of dataTable
  $('#users_table').dataTable(
                      {
                        "order": [[0, 'desc' ]],
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                       })
  #***** end of dataTable
  
