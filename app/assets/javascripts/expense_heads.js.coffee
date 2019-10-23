datatable_initialize = ->
  row = 0
  id = 0
  importsTable = $('#expense_table_id').dataTable({
                    "bJQueryUI": true
                    "bFilter": true,
                    "bPaginate": false
                    })
$(document).ready datatable_initialize
