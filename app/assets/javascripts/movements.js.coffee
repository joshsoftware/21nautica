# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
datatable_initialize = ->
  row = 0
  id = 0
  movementsTable = $('#movements_index_table').dataTable({
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
                        	  {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.ajax(
                                      url:"movements/update",
                                      type: 'POST'
                                      data: {id:id,columnName:"BL Number",value:value},
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
                                  fnOnCellUpdated: (sStatus,sValue,settings) ->
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
                                      data: {id:id,columnName:"Transporter Payment",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
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
                                      data: {id:id,columnName:"Clearing Agent",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
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
                                      data: {id:id,columnName:"Clearing Agent Payment",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
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
                                       $.post("movements/update",{id:id,columnName:"Port of discharge",value:value})
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


history_datatable_initialize = ->
  movementsTable =  $('#movements_history_table').dataTable({
                      "sAjaxSource": "/export/history.json",
                      "bJQueryUI": true,
                      "deferRender" : true,
                      "columns": [
                        {"data": "w_o_number"},
                        {"data": "booking_number"},
                        {"data": "bl_number"},
                        {"data": "customer_name"},
                        {"data": "container_number"},
                        {"data" : "truck_number"},
                        {"data" : "transporter_name"},
                        {"data" : "transporter_invoice_number"},
                        {"data" : "transporter_invoice_date"},
                        {"data" : "transporter_payment"},   
                        {"data" : "clearing_agent"},
                        {"data" : "clearing_agent_invoice_number"},
                        {"data" : "clearing_agent_invoice_date"},
                        {"data" : "clearing_agent_payment"},
                        {"data" : "vessel_targeted"},
                        {"data" : "port_of_discharge"},
                        {"data" : "movement_type"},
                        {"data" : "shipping_seal"},
                        {"data": "remarks" }
                      ]
                    }).makeEditable({       
                        aoColumns: [
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          }, null, null,
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            type: 'select',
                            event: 'click',
                            data: JSON.stringify(@transporters),
                            onblur: 'submit',
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            type: 'datepicker2',
                            event: 'click',
                            submit: 'okay',
                            tooltip: "yyyy-mm-dd",
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },        
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },      
                          {
                            type: 'datepicker2',
                            event: 'click',
                            submit: 'okay',
                            tooltip: "yyyy-mm-dd",
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          },
                          {
                            type: 'select',
                            event: 'click'
                            data: JSON.stringify(@destination_ports),
                            onblur: 'submit',
                            sUpdateURL: "../movements/update"
                            fnOnCellUpdated: (sValue) ->
                              return sValue
                          }, null, null, null
                        ]

                      })


$(document).ready history_datatable_initialize



