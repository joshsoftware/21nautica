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
                                  null,null,null,null,
                                  {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.post("import_items/update",{id:id,columnName:"Truck Number",value:value})
                                    return value
                                  , placeholder:"Click to enter",

                                  fnOnCellUpdated: (sStatus, sValue, settings) ->
                                    $("#import_items_table tr##{id} .text-center .btn.btn-small.btn-primary").attr('data-truck-number',sValue)
                                    if($("[data-importitem-id="+ id +  "]").attr('truck-number-alloted') == 'false')
                                      $("[data-importitem-id="+ id +  "]").attr('truck-number-alloted','true')
                                      $.post("import_items/#{id}/updateStatus",{import_item: {status:"allocate_truck",truck_number: sValue}})

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
                                  null, null
                                 ]
                  )

$(document).ready datatable_initialize

datatable_initialize = ->
    ohistoryTable = $('#import_history_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
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