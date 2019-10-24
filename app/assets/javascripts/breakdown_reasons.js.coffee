datatable_initialize = ->
 row = 0
 id = 0
 imitemsTable = $('#breakdown_reason_table_id').dataTable({
                   "bJQueryUI": false,
                   "bFilter": true,
                   'bPaginate': false
                   })
$(document).ready datatable_initialize
