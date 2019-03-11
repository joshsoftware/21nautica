$(document).ready ->

  $('#trucks_table').dataTable(
                      {
                        "order": [[0, 'asc' ]],
                        "bJQueryUI": true
                        "bFilter": true
                        "sPaginationType": "full_numbers"
                       })

