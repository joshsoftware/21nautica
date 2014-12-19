# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_paid_index_table = ->
  participants_name = $(this).val()
  $.ajax
    url: "/paid"
    type: "GET"
    data:
      participants_name: participants_name

$(document).on "page:load ready", ->
  $("#paid_participants_name" ).change(show_paid_index_table)
  $("#paid_payment_date").datepicker(
    format :"dd-mm-yyyy")
  $("#paid_payment_date").datepicker('setDate', new Date())
  return