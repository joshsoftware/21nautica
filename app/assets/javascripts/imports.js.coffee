# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:load ready", ->
  $(".date").datepicker(
    format :"dd-mm-yyyy")
  return

$(document).on 'change', '#destination', ->
  destination = $('#destination option:selected').text()
  this.form.submit()

$(document).on 'change', '#import_from', ->
  $el = $("#import_to")
  optionSelected = $(this).find("option:selected").text()
  if (optionSelected == "Dar Es Salaam")
    newOptions = window.ports["Dar Es Salaam"]
    $("#import_to").find("option:gt(0)").remove()
    $.each newOptions, (index, value) ->
      $el.append $('<option></option>').attr('value', value).text(value)
#$el.val('Kigali')
  else
    newOptions = window.ports["Mombasa"]
    $("#import_to").find("option:gt(0)").remove()
    $.each newOptions, (index, value) ->
      $el.append $('<option></option>').attr('value', value).text(value)
#$el.val('Kampala')

datatable_initialize = ->
  row = 0
  id = 0
  importsTable = $('#imports_table').dataTable({
                    "bJQueryUI": true
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      sUpdateURL: 'imports/update',
                      aoColumns: [null, null, null,
                                  null, null, null,
                                  null, null, null,
                                  null
                                 ])

$(document).ready datatable_initialize

