# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('body').on 'change', '#spare_part_spare_part_category_id', ->
    category_id = $(this).val()
    if category_id
      $.get('/spare_parts/load_sub_categories', {spare_part_category_id: category_id }).done (data) ->
        $('#spare_part_spare_part_sub_category_id').html('')
        $.each data,(index, value) ->
          $('#spare_part_spare_part_sub_category_id').append('<option value='+value[1]+'>'+value[0]+'</option>')
        console.log(data)
    else
      $('#spare_part_spare_part_sub_category_id').html('')
