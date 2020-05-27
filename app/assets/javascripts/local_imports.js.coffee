# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:load ready", ->
  $(".date").datepicker(format :"dd-mm-yyyy")


datatable_initialize = ->
  row = 0
  id = 0
  localImportsTable = $('#local_imports_table').dataTable({
                    "bJQueryUI": true
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      sUpdateURL: 'local_imports/update',
                      aoColumns: [null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null, null
                                 ])

$(document).ready datatable_initialize

