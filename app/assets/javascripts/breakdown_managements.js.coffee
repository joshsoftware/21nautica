# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'change', '#status', ->
  status =  $('#status option:selected').text()
  this.form.submit()


datatable_initialize = ->
 row = 0
 id = 0
 imitemsTable = $('#breakdown_table_id').dataTable({
                   "bJQueryUI": false,
                   "bFilter": true,
                   'bPaginate': false
                   })
$(document).ready datatable_initialize
