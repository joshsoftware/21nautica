# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@filterInit = ->
  FilterJS items, "#search_result",
    template: "#search_result_template"
    search:
      ele: "#searchbox"
