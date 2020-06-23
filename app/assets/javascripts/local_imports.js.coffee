# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:load ready", ->
  $(".date").datepicker(format :"dd-mm-yyyy")


datatable_initialize = ->
  row = 0
  id = 0
  localImportsTable = $('#local_imports_table').dataTable({
                    "bJQueryUI": true
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      sUpdateURL: 'local_imports/update',
                      aoColumns: [null, null, null,
                                  null, {
                                    type: 'datepicker2',
                                    event: 'click',
                                    submit: 'okay',
                                    tooltip: "yyyy-mm-dd",
                                    sUpdateURL: (value, settings) ->
                                      row = $(this).parents('tr')[0]
                                      id = row.id
                                      $.ajax(
                                        url:"local_imports/#{id}",
                                        type: 'PUT'
                                        data: {id:id, columnName:"estimated_arrival", value:value}
                                        async: false
                                      ).done((data) ->
                                        value = data
                                      )
                                      return value
                                    ,
                                    fnOnCellUpdated: (sStatus, sValue, settings) ->
                                      #$.post("imports/#{id}/retainStatus")
                                  }, null,
                                  null, null, null,
                                  null, null
                                 ])

$(document).ready datatable_initialize

