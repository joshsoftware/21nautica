# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:load ready", ->
  $(".date").datepicker(
    format :"dd-mm-yyyy")
  return

datatable_initialize = ->
  importsTable = $('#imports_table').dataTable({
                    "bJQueryUI": true
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      sUpdateURL: 'imports/update',
                      aoColumns: [
                                  null,null,null,null,
                                  { sUpdateURL: 'imports/update',placeholder:"Click to enter",},
                                  null, null, null
                                 ]
                  )

$(document).ready datatable_initialize