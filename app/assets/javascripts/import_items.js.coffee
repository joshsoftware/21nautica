# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '#destination_item', ->
  destination_item =  $('#destination_item option:selected').text()
  this.form.submit()

import_item_datatable_initialize = ->
  row = 0
  id = 0
  importsTable = $('#import_items_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers",
                    }).makeEditable(
                      sUpdateURL: 'import_items/update',
                      aoColumns: [null, null, null, null, null, null,
                                  {
                                    type: 'datepicker2',
                                    event: 'click',
                                    submit: 'okay',
                                    tooltip: "yyyy-mm-dd",
                                    sUpdateURL: (value, settings) ->
                                      row = $(this).parents('tr')[0]
                                      id = row.id
                                      $.ajax(
                                        url:"import_items/update",
                                        type: 'POST'
                                        data: {id:id, columnName:"Last Loading Date", value:value}
                                        async: false
                                      ).done((data) ->
                                        value = data
                                      )
                                      return value
                                    ,
                                    fnOnCellUpdated: (sStatus, sValue, settings) ->
                                      #$.post("imports/#{id}/retainStatus")
                                  },
                                  null, null
                                 ])



datatable_initialize = ->
    oemptycontTable = $('#import_empty_containers_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      aoColumns: [
                                  null,null,null,
                                  {name: 'g_f_expiry', submit: 'okay', tooltip: "yyyy-mm-dd", sUpdateURL:  "import_items/update", type: 'datepicker2', event: 'click'},
                                  null,
                                  null, null, null, null
                                 ]
                  )
$(document).ready -> 
  datatable_initialize()
  import_item_datatable_initialize()
