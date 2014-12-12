# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:load ready", ->
  $("#received_payment_date").datepicker(
    format :"dd-mm-yyyy")
  $("#received_payment_date").datepicker('setDate', new Date())
  return