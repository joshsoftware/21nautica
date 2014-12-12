# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:load ready", ->
  $("#paid_payment_date").datepicker(
    format :"dd-mm-yyyy")
  $("#paid_payment_date").datepicker('setDate', new Date())
  return