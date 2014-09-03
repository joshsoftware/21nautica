# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

datatable_initialize = ->
    imitemsTable = $('#import_items_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      aoColumns: [
                                  null,null,null,null,
                                  {sUpdateURL: 'import_items/update', placeholder:"Click to enter",
                                  fnOnCellUpdated: (sStatus, sValue, settings) ->
                                    id = $('.last-updated-cell').parents('tr').attr('id')
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
                                      sUpdateURL: 'import_items/update',
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
                                  null, null
                                 ]
                  )

$(document).ready datatable_initialize

datatable_initialize = ->
    oemptycontTable = $('#import_empty_containers_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    })
$(document).ready datatable_initialize