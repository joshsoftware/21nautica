# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
datatable_initialize = ->
  @transjson = {}
  @destjson = {}
  for i in @transporters
    @transjson[i] = i

  for i in @destination_ports
    @destjson[i] = i
   
  movementsTable = $('#movements_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                  }).makeEditable(
                     sUpdateURL: 'movements/update',
                     aoColumns: [ {
                                    sUpdateURL: 'movements/update',},
                                  null,
                                  {sUpdateURL: 'movements/update',},
                                  {
                                    type: 'select',
                                    event: 'click',
                                    data: JSON.stringify(@transjson),
                                    submit: 'Ok'
                                    sUpdateURL: 'movements/update', 
                                    },
                                  {sUpdateURL: 'movements/update',},
                                  { 
                                    type: 'select',
                                    event: 'click'
                                    data: JSON.stringify(@destjson),
                                    onblur: 'submit'
                                    sUpdateURL: 'movements/update',
                                    },
                                  null, null, null,
                                  {sUpdateURL: 'movements/update',},
                                  null,null
                     ]
                  )

$(document).on "page:load", datatable_initialize
$(document).ready datatable_initialize

