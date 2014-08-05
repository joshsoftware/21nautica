# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
datatable_initialize = ->
  movementsTable = $('#movements_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                  }).makeEditable(
                     sUpdateURL: 'movements/update',
                     aoColumns: [ {sUpdateURL: 'movements/update',},
                                  {sUpdateURL: 'movements/update',},
                                  {sUpdateURL: 'movements/update',},
                                  {sUpdateURL: 'movements/update',},
                                  null, null, null
                     ]
                  )

$(document).on "page:load", datatable_initialize
$(document).ready datatable_initialize
