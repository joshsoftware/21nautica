# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:load ready", ->
  $(".date").datepicker(
    format :"dd-mm-yyyy")
  return

datatable_initialize = ->
  row = 0
  id = 0
  importsTable = $('#imports_table').dataTable({
                    "bJQueryUI": true
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      sUpdateURL: 'imports/update',
                      aoColumns: [
                                  {
                                    type: 'select',
                                    event: 'click',
                                    data: JSON.stringify(@customers),
                                    onblur: 'submit',
                                    sUpdateURL: (value,settings)->
                                       row = $(this).parents('tr')[0]
                                       id = row.id
                                       $.post("imports/update",{id:id,columnName:"customer id",value:value})
                                       return value
                                     , placeholder:"Click to enter",
                                     fnOnCellUpdated: (sStatus,sValue,settings) ->
                                       $.post("imports/#{id}/retainStatus")
                                  },
                                  null,null,
                                  {
                                    type: 'select',
                                    event: 'click',
                                    data: JSON.stringify(@equipment),
                                    onblur: 'submit'
                                    sUpdateURL: (value, settings) ->
                                      row = $(this).parents('tr')[0]
                                      id = row.id
                                      $.ajax(
                                        url:"imports/update",
                                        type: 'POST'
                                        data: {id:id, columnName:"Equipment", value:value}
                                        async: false
                                      ).done((data) ->
                                        value = data
                                      )
                                      return value 
                                    , placeholder:"Click to enter",
                                    fnOnCellUpdated: (sStatus, sValue, settings) ->
                                      $.post("imports/#{id}/retainStatus")     
                                  }, null,
                                  {sUpdateURL: (value,settings)->
                                    row = $(this).parents('tr')[0]
                                    id = row.id
                                    $.ajax(
                                      url:"imports/update",
                                      type: 'POST'
                                      data: {id:id,columnName:"Work Order Number",value:value},
                                      async: false)
                                      .done((data) ->
                                        if (data != value)
                                          value = data
                                      )
                                    return value
                                  , placeholder:"Click to enter",
                                  fnOnCellUpdated: (sStatus, sValue, settings) ->
                                    $.post("imports/#{id}/retainStatus")},


                                  null, null, null,null
                                 ]
                  )

$(document).ready datatable_initialize