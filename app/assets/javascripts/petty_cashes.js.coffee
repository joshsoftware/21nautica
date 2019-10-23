datatable_initialize = ->
  row = 0
  id = 0
  importsTable = $('#petty_cash_table').dataTable({
                    "bJQueryUI": true
                    "bFilter": true,
                    "bPaginate": false
                    })
$(document).ready datatable_initialize
