# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@InvoiceFilterInit = ->
  FilterJS invoices, "#invoices_search_result",
    template: "#invoices_search_result_template"
    search:
      ele: "#invoices_searchbox"