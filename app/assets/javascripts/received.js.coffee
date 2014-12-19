# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_received_index_table = ->
  participants_name = $(this).val()
  $.ajax
    url: "/received"
    type: "GET"
    data:
      participants_name: participants_name

$(document).on "page:load ready", ->
  $("#received_participants_name").change(show_received_index_table)
  $("#received_payment_date").datepicker(
    format :"dd-mm-yyyy")
  $("#received_payment_date").datepicker('setDate', new Date())
  return