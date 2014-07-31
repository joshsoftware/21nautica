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
    });  
  );
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
      exportsTable.fnOpen(nTr, fnFormatDetails(id, detailsTableHtml), 'details');
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
          "<a href='#'' class='btn btn-lg btn-primary' data-toggle='modal'   
              data-target='#basicModal' >Movement</a>"
      }).makeEditable({
        sUpdateURL: '/export_items/update'
        sAddURL: '/export_items?export_id='+id
      });

$(document).on "page:load", datatable_initialize
$(document).ready datatable_initialize
