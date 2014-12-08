# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:load ready", ->
  $("#payment_date").datepicker(
    format :"dd-mm-yyyy")
  $("#payment_date").datepicker('setDate', new Date())
  return
