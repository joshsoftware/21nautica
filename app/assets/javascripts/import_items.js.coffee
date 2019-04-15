# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '#destination_item', ->
  destination_item =  $('#destination_item option:selected').text()
  this.form.submit()

datatable_initialize = ->
  row = 0
  id = 0
  imitemsTable = $('#import_items_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      aoColumns: [
                                  null,null,null,null,null,
                                  null, null, null, null
                                 ]
                  )

$(document).ready datatable_initialize

history_datatable_initialize = ->
    ohistoryTable = $('#import_history_table').dataTable({
                    "sAjaxSource": "/import/history.json",
                    "bJQueryUI": true,
                    "bAutoWidth": false,
                    "deferRender" : true,
                    "aoColumns": [{ "sWidth": "10%", "data" : "bl_number"},
                    { "sWidth": "10%", "data" : "container_number" },
                    { "sWidth": "5%", "data" : "work_order_number" },
                    { "sWidth": "5%", "data": "truck_number"}
                    { "sWidth": "10%", "data" : "customer_name" },
                    { "sWidth": "5%", "data" : "clearing_agent" },
                    { "sWidth": "5%", "data" : "transporter_name" },
                    { "sWidth": "5%", "data" : "equipment_type" },
                    { "sWidth": "10%", "data" : "delivery_date" },
                    { "sWidth": "10%", "data" :  "after_delivery_status"}
                    { "sWidth": "15%", "data" : "context" },
                    { "sWidth": "10%", "data" : "formatted_close_date" }]
                    }).makeEditable(
                      aoColumns: [
                                  null, null, null, null, null, null, null, 
                                  null, null, null, null,
                                  {name: 'close_date', submit: 'okay', tooltip: "yyyy-mm-dd",
                                  sUpdateURL:  "../import_items/update",
                                  type: 'datepicker2', event: 'click',
                                  fnOnCellUpdated: (sValue) ->
                                    return sValue
                                  }
                                 ]
                  )

#$(document).ready history_datatable_initialize

datatable_initialize = ->
    oemptycontTable = $('#import_empty_containers_table').dataTable({
                    "bJQueryUI": true,
                    "bFilter": true,
                    "sPaginationType": "full_numbers"
                    }).makeEditable(
                      aoColumns: [
                                  null,null,null,
                                  {name: 'g_f_expiry', submit: 'okay', tooltip: "yyyy-mm-dd", sUpdateURL:  "import_items/update"
                                  ,type: 'datepicker2', event: 'click'},
                                  null,
                                  null, null
                                 ]
                  )
$(document).ready datatable_initialize


window.load_history_stream = ->

  callbacks =
    after_add: ->
      if count is this.data.length
        $(".streaming_div").hide()
      if $.trim($('#table-search').val()) isnt ''
        total_records = this.last_search_result.length
      else
        total_records = parseInt($('#records_found').text()) || 0
        total_records += this.data.length
      $('#records_found').text("Result found " + total_records)


  template = $.trim($('#import_history_template').html())
  Mustache.parse template

  view = (record, index) ->
    Mustache.render template,
      record: record
      index: index

  options = {

    view: view
    data_url: '/import/history.json'
    stream_after: 2
    fetch_data_limit: 100
    callbacks: callbacks
    pagination:{
      span: 5,
      next_text: 'Next &rarr;',
      prev_text: '&larr; Previous',
      container_class: 'text-center',
      per_page_select: true,
      per_page_class: 'hide'
    },
    search_box: '#table-search'
  }

  $('#import_history_table').stream_table(options, import_items)



$(document).ready ->

  $('body').on 'keyup', '#table-search', ->
    str = $('#import_history_table').data('st')
    result = str.last_search_result.length
    $('#records_found').text('Result found ' + result)

