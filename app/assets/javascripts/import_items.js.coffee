# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

datatable_initialize = ->
  imitemsTable = $('#import_items_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      sUpdateURL: 'import_items/update',
                      aoColumns: [
                                  null,null,null,null,
                                  { sUpdateURL: 'import_items/update', placeholder:"Click to enter",},
                                  null
                                 ]
                  )

$(document).ready datatable_initialize