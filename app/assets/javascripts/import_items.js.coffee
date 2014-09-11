# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

datatable_initialize = ->
  row = 0
  id = 0
  imitemsTable = $('#import_items_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      aoColumns: [
                                  null,null,null,null,null,
                                  {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.ajax(
                                      url:"import_items/update",
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
                                    switch sStatus
                                      when "success"
                                        $.post("import_items/#{id}/updateStatus",{import_item:{status:"allocate_truck",truck_number: sValue}})
                                    },
                                    {
                                      type: 'select',
                                      event: 'click',
                                      data: JSON.stringify(@transporters),
                                      onblur: 'submit'
                                      sUpdateURL: (value,settings)->
                                       row = $(this).parents('tr')[0]
                                       id = row.id
                                       $.post("import_items/update",{id:id,columnName:"Transporter Name",value:value})
                                       return value
                                     , placeholder:"Click to enter",
                                     fnOnCellUpdated: (sStatus,sValue,settings) ->
                                       $.post("import_items/#{id}/updateStatus",{import_item: {status:"allocate_truck",transporter: sValue}})
                                    },
                                  null, null,null
                                 ]
                  )

$(document).ready datatable_initialize

datatable_initialize = ->
    ohistoryTable = $('#import_history_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers",
                    "bAutoWidth": false,
                    "aoColumns": [{ "sWidth": "10%" }, { "sWidth": "10%" }, { "sWidth": "10%" }, { "sWidth": "20%" }, { "sWidth": "40%" }, { "sWidth": "10%" }]
                    }).makeEditable(
                      aoColumns: [
                                  null,null,null,null,
                                  null,
                                  {name: 'close_date', submit: 'okay', tooltip: "yyyy-mm-dd", sUpdateURL:  "import_items/update"
                                  ,type: 'datepicker2', event: 'click'}
                                 ]
                  )

$(document).ready datatable_initialize

datatable_initialize = ->
    oemptycontTable = $('#import_empty_containers_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      aoColumns: [
                                  null,null,null,
                                  {name: 'g_f_expiry', submit: 'okay', tooltip: "yyyy-mm-dd", sUpdateURL:  "import_items/update"
                                  ,type: 'datepicker2', event: 'click'},
                                  null,
                                  null, null
                                 ]
                  )
$(document).ready datatable_initialize
