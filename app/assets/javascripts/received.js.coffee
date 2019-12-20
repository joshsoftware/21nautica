# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_received_index_table = ->
  $("span.invoiced").text("0")
  $("span.received").text("0")
  $("span.opening_balance").text("0")
  $("span.closing_balance").text("0")
  customer_id = $(this).val()
  if customer_id
    $.ajax
      url: "/received"
      type: "GET"
      data:
        customer_id: customer_id

$(document).on "page:load ready", ->
  $("#customer_id").change(show_received_index_table)
  return