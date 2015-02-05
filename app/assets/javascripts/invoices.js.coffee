# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

stream_table_function = ->

  template = Mustache.compile($.trim($('#invoices_search_result_template').html()))

  view = (record, index) ->
    template
      record: record
      index: index

  if($("#invoices_index_table").length)
    options = 
      view: view
      data_url: '/invoices.json'
      stream_after: 2
      fetch_data_limit: 10

    st = StreamTable('#invoices_index_table', options, data)

$(document).ready(stream_table_function)
$(document).on 'page:load', stream_table_function