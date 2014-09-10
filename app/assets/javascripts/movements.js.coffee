# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
datatable_initialize = ->
  row = 0
  id = 0
  movementsTable = $('#movements_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                  }).makeEditable(

                     aoColumns: [ {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.ajax(
                                      url:"movements/update",
                                      type: 'POST'
                                      data: {id:id,columnName:"Booking Number",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
                                    return value
                                  , placeholder:"Click to enter",
                                  fnOnCellUpdated: (sStatus, sValue, settings) ->
                                    $.post("movements/#{id}/retainStatus")
                                    },
                                  null,
                                  {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.ajax(
                                      url:"movements/update",
                                      type: 'POST'
                                      data: {id:id,columnName:"Truck Number",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
                                    return value
                                  , placeholder:"Click to enter",
                                  fnOnCellUpdated: (sStatus, sValue, settings) ->
                                    $.post("movements/#{id}/retainStatus")
                                    },
                                  {
                                    type: 'select',
                                    event: 'click',
                                    data: JSON.stringify(@transporters),
                                    onblur: 'submit',
                                    sUpdateURL: (value,settings)->
                                       row = $(this).parents('tr')[0]
                                       id = row.id
                                       $.post("movements/update",{id:id,columnName:"Transporter Name",value:value})
                                       return value
                                     , placeholder:"Click to enter",
                                     fnOnCellUpdated: (sStatus,sValue,settings) ->
                                       $.post("movements/#{id}/retainStatus")
                                  },
                                  {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.ajax(
                                      url:"movements/update",
                                      type: 'POST'
                                      data: {id:id,columnName:"Vessel Targeted",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
                                    return value
                                  ,fnOnCellUpdated: (sStatus, sValue, settings) ->
                                    $.post("movements/#{id}/retainStatus")},
                                  {
                                    type: 'select',
                                    event: 'click'
                                    data: JSON.stringify(@destination_ports),
                                    onblur: 'submit'
                                    sUpdateURL: (value,settings)->
                                       row = $(this).parents('tr')[0]
                                       id = row.id
                                       $.post("movements/update",{id:id,columnName:"Port of destination",value:value})
                                       return value
                                     , placeholder:"Click to enter",
                                     fnOnCellUpdated: (sStatus,sValue,settings) ->
                                       $.post("movements/#{id}/retainStatus")
                                    },
                                  null, null, null,
                                  {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.ajax(
                                      url:"movements/update",
                                      type: 'POST'
                                      data: {id:id,columnName:"W_O_number",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
                                    return value
                                  , placeholder:"Click to enter",
                                  fnOnCellUpdated: (sStatus, sValue, settings) ->
                                    $.post("movements/#{id}/retainStatus")},
                                  null,null
                     ]
                  )

$(document).ready datatable_initialize

