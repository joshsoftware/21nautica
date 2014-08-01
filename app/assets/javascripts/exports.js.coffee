# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
fnFormatDetails = (table_id, html) ->
    sOut = "<table id=\"exportItem_" + table_id + "\">"
    sOut += html
    sOut += "</table>"
    return sOut

defaultEditable = ->
  tooltip: 'Click to edit',
  indicator: "Saving..."
  sUpdateURL: "export_items/update"
  submit:'Save changes',
  fnOnCellUpdated: (sStatus, sValue, settings) ->
    alert("(Cell Callback): Cell is updated with value " + sValue)

fnOnCellUpdated = (sStatus, sValue, a, b, settings) ->
  alert("wtf" +  sStatus)

datatable_initialize = ->

  $(document).on("dialogopen", ".ui-dialog", (event, ui) ->
    $('[data-behaviour~=datepicker]').datepicker({
      dateFormat: 'yy-mm-dd'
    })
  )
  exportsTable = $('#exports_table').dataTable({
                    "bJQueryUI": true
                    "sPaginationType": "full_numbers"
                  })
  detailsTableHtml = $("#detailsTable").html()

  $('#exports_table tbody td img').click ->
    nTr = $(this).parents('tr')[0]
    nTds = this
   
    id = $(this).parents('tr').attr('id')

    if exportsTable.fnIsOpen(nTr)
      # This row is already open - close it
      this.src = "/images/plus.png"
      exportsTable.fnClose(nTr)
    
    else
      # Open this row
      rowIndex = exportsTable.fnGetPosition( $(nTds).closest('tr')[0] )
      detailsRowData = exportItems[rowIndex]
      this.src = "/images/minus.png"
      exportsTable.fnOpen(nTr, fnFormatDetails(id, detailsTableHtml), 'details')
      oInnerTable = $("#exportItem_" + id).dataTable({
      "bJQueryUI": true,
      "bFilter": false,
      "aaData": detailsRowData,
      "bPaginate": false,
      "aoColumns": [
                    { "mDataProp": "container" },
                    { "mDataProp": "date_of_placement" },
                    { "mDataProp": "location" },
                    { "mDataProp": "id" }
                    ],
      columnDefs: [
        targets: 3,
        render: (data, type, full, meta) ->
          console.log(full)
          $('#basicModal #export_item_id1').val full.id
          $('#basicModal #export_item_id').val full.export_id
          "<a href='#'' id='movement_#{full.id}' class='btn btn-small btn-primary' data-toggle='modal'   
              data-target='#basicModal' data-row='##{full.id}'>Movement</a>"
      ],
      createdRow: ( row, data, index ) ->
         $(row).attr('id', data.id)
      })

     oInnerTable.makeEditable(
        aoColumns: [ { name: "container", sUpdateURL: "export_items/update" },
                     { name: 'date_of_placement', sUpdateURL: "export_items/update"},
                     { name: 'location', sUpdateURL: "export_items/update"}, null
                   ]
      )

$(document).on "page:load", datatable_initialize
$(document).ready datatable_initialize
