$(document).ready ->
    $(document).on "page:load", ->
        $("[data-for='multiselect']").select2()
