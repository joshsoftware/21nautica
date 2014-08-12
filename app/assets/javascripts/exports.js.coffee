# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
fnFormatDetails = (table_id, html) ->
    sOut = "<table id=\"exportItem_" + table_id + "\">"
    sOut += html
    sOut += "</table>"
    return sOut

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
      rowIndex = $(nTr).attr("id")
      detailsRowData = exportItems[rowIndex]
      this.src = "/images/minus.png"
      exportsTable.fnOpen(nTr, fnFormatDetails(id, detailsTableHtml), 'details')
      oInnerTable = $("#exportItem_" + id).dataTable({
      "bJQueryUI": true,
      "bFilter": false,
      "aaData": detailsRowData,
      "bPaginate": false,
      "aoColumns": [
                    { "mDataProp": "date_of_placement" },
                    { "mDataProp": "container" },
                    { "mDataProp": "location"},
                    { "mDataProp": "date_since_placement"}
                    ],
      columnDefs: [
        {targets: 4,
        render: (data, type, full, meta) ->
          "<a href='#'' id='movement_#{full.id}' class='btn btn-small btn-primary btn-movement' data-toggle='modal'
             data-target='#basicModal', data-container='#{full.container}' data-export='##{full.export_id}' data-row='##{full.id}'>Movement</a>"
        },
      ],
      fnCreatedRow: ( row, data, index ) ->
        $(row).attr('id', data.id)   
      }).makeEditable(
        oAddNewRowOkButtonOptions: null
        oAddNewRowCancelButtonOptions: null
        aoColumns: [ {name: 'date_of_placement', submit: 'okay', tooltip: "yyyy-mm-dd", sUpdateURL: "export_items/update", type: 'datepicker', event: 'click'},
                     { name: "container", onblur: 'submit', sUpdateURL: "export_items/update",placeholder:"Click to enter Container", fnOnCellUpdated: (sStatus, sValue, settings) ->
                                   eval(sValue) }
                     { name: 'location', onblur: 'submit', sUpdateURL: "export_items/update",placeholder:"Click to enter Location"}, null, null
                   ]
      )

$(document).ready datatable_initialize
