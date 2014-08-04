# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
fnFormatDetails = (table_id, html) ->
    sOut = "<table id=\"movementList_" + table_id + "\">"
    sOut += html
    sOut += "</table>"
    return sOut

datatable_initialize = ->

  movementsTable = $('#movements_table').dataTable({
                    "bJQueryUI": true
                    "sPaginationType": "full_numbers"
                  })
  detailsTableHtml = $("#detailsTable").html()

  $('#movements_table tbody td img').click ->
    nTr = $(this).parents('tr')[0]
    nTds = this
   
    id = $(this).parents('tr').attr('id')

    if movementsTable.fnIsOpen(nTr)
      # This row is already open - close it
      this.src = "/images/plus.png"
      movementsTable.fnClose(nTr)
    else
      # Open this row
      detailsRowData = movementsList[($(nTds).closest('tr')[0]).id]  
      this.src = "/images/minus.png"
      movementsTable.fnOpen(nTr, fnFormatDetails(id, detailsTableHtml), 'details');
  
      oInnerTable = $("#movementList_" + id).dataTable({
      "bJQueryUI": true,
      "bFilter": false,
      "aaData": detailsRowData,
      "bPaginate": false,
      "aoColumns": [
                    { "mDataProp": "id" },
                    { "mDataProp": "truck_number" },
                    { "mDataProp": "vessel_targeted" },
                    { "mDataProp": "port_of_destination" },
                    { "mDataProp": "container_number" },
                    { "mDataProp": "movement_type" },
                    { "mDataProp": "shipping_seal" }
                    ]
      });

$(document).on "page:load", datatable_initialize
$(document).ready datatable_initialize
